SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: events_creation_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.events_creation_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    payload text;
  BEGIN
    payload = json_build_object('city_id',  NEW.city_id,
                                'topic_id', NEW.topic_id,
                                'start',    NEW.start);
    EXECUTE 'NOTIFY events_creation, ' || quote_literal(payload);
    RETURN NULL;
  END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title text NOT NULL,
    place text NOT NULL,
    start timestamp without time zone NOT NULL,
    finish timestamp without time zone NOT NULL,
    city_id uuid NOT NULL,
    topic_id uuid NOT NULL,
    creator_id uuid NOT NULL,
    CONSTRAINT events_check_start_is_less_than_finish CHECK ((start < finish))
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topics (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title text NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    email text NOT NULL,
    password_digest text NOT NULL,
    filter_city_id uuid,
    filter_topic_id uuid,
    filter_start timestamp without time zone,
    CONSTRAINT users_email_format_check CHECK ((email ~ '\A[\w._-]+@[\w._-]+\Z'::text))
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: cities_lower_name_unique_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cities_lower_name_unique_key ON public.cities USING btree (lower(name));


--
-- Name: index_events_on_city_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_city_id ON public.events USING btree (city_id);


--
-- Name: index_events_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_creator_id ON public.events USING btree (creator_id);


--
-- Name: index_events_on_start; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_start ON public.events USING btree (start);


--
-- Name: index_events_on_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_topic_id ON public.events USING btree (topic_id);


--
-- Name: index_users_on_filter_city_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_filter_city_id ON public.users USING btree (filter_city_id);


--
-- Name: index_users_on_filter_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_filter_topic_id ON public.users USING btree (filter_topic_id);


--
-- Name: topics_lower_title_unique_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX topics_lower_title_unique_key ON public.topics USING btree (lower(title));


--
-- Name: users_lower_email_unique_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_lower_email_unique_key ON public.users USING btree (lower(email));


--
-- Name: events events_creation_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER events_creation_trigger AFTER INSERT ON public.events FOR EACH ROW EXECUTE PROCEDURE public.events_creation_trigger();


--
-- Name: events fk_rails_07b11fc6bb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_07b11fc6bb FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: events fk_rails_15c34a9137; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_15c34a9137 FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: users fk_rails_b462abf33e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_b462abf33e FOREIGN KEY (filter_topic_id) REFERENCES public.topics(id);


--
-- Name: events fk_rails_e5e78194cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_e5e78194cb FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: users fk_rails_fbc05fe8ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_fbc05fe8ec FOREIGN KEY (filter_city_id) REFERENCES public.cities(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO "schema_migrations" (version) VALUES
('20180908124326'),
('20180908125414'),
('20180914062139'),
('20180916081935'),
('20180916092217'),
('20181003115006'),
('20181005103914');


