# frozen_string_literal: true

# Class of migrations which create table of topics
class CreateTopics < ActiveRecord::Migration[5.2]
  # Creates or drops table of topics
  def change
    create_table :topics, id: :uuid, default: 'gen_random_uuid()' do |topics|
      topics.text :title, null: false
    end

    reversible do |direction|
      direction.up { execute <<-SQL }
        CREATE UNIQUE INDEX topics_lower_title_unique_key
          ON topics (lower(title))
      SQL

      direction.down { execute 'DROP INDEX topics_lower_title_unique_key' }
    end
  end
end
