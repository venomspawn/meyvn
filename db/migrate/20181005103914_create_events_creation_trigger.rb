# frozen_string_literals: true

# Class of migrations which add a trigger on events creation
class CreateEventsCreationTrigger < ActiveRecord::Migration[5.2]
  # Adds a trigger on events creation
  def change
    reversible do |direction|
      direction.up do
        execute <<~SQL
          CREATE FUNCTION events_creation_trigger() RETURNS trigger AS $$
            DECLARE
              city_name   text;
              topic_title text;
              payload     text;
            BEGIN
              SELECT name
                INTO city_name
                FROM cities
                WHERE id = NEW.city_id;

              SELECT title
                INTO topic_title
                FROM topics
                WHERE id = NEW.topic_id;

              payload = json_build_object(
                          'event_id',     NEW.id,
                          'event_title',  NEW.title,
                          'event_place',  NEW.place,
                          'event_start',  NEW.start,
                          'event_finish', NEW.finish,
                          'creator_id',   NEW.creator_id,
                          'city_name',    city_name,
                          'topic_title',  topic_title,
                          'city_id',      NEW.city_id,
                          'topic_id',     NEW.topic_id
                        );

              EXECUTE 'NOTIFY events_creation, ' || quote_literal(payload);

              RETURN NULL;
            END;
          $$ LANGUAGE plpgsql;

          CREATE TRIGGER events_creation_trigger
            AFTER INSERT ON events
            FOR EACH ROW EXECUTE PROCEDURE events_creation_trigger();
        SQL
      end

      direction.down do
        execute <<~SQL
          DROP TRIGGER events_creation_trigger ON events;
          DROP FUNCTION events_creation_trigger();
        SQL
      end
    end
  end
end
