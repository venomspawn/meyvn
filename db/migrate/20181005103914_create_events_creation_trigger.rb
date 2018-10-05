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
              payload text;
            BEGIN
              payload = json_build_object('city_id',  NEW.city_id,
                                          'topic_id', NEW.topic_id,
                                          'start',    NEW.start);
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
