# frozen_string_literal: true

# Class of migrations which create table of events
class CreateEvents < ActiveRecord::Migration[5.2]
  # Creates or drops table of events
  def change
    create_table :events, id: :uuid, default: 'gen_random_uuid()' do |events|
      events.column :title,  :text, null: false
      events.column :place,  :text, null: false
      events.column :start,  :timestamp, null: false, index: true
      events.column :finish, :timestamp, null: false

      events.belongs_to :city,
                        type:        :uuid,
                        null:        false,
                        foreign_key: true,
                        index:       true

      events.belongs_to :topic,
                        type:        :uuid,
                        null:        false,
                        foreign_key: true,
                        index:       true

      events.belongs_to :creator,
                        type:        :uuid,
                        null:        false,
                        foreign_key: { to_table: :users }
    end

    reversible do |direction|
      direction.up { execute <<-SQL }
        ALTER TABLE events
          ADD CONSTRAINT events_check_start_is_less_than_finish
            CHECK (start < finish)
      SQL

      direction.down { execute <<-SQL }
        ALTER TABLE events
          DROP CONSTRAINT events_check_start_is_less_than_finish
      SQL
    end
  end
end
