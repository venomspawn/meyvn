# frozen_string_literal: true

# Class of migrations which create table of cities
class CreateCities < ActiveRecord::Migration[5.2]
  # Creates or drops table of cities
  def change
    create_table :cities, id: :uuid, default: 'gen_random_uuid()' do |cities|
      cities.text :name, null: false
    end

    reversible do |direction|
      direction.up { execute <<-SQL }
        CREATE UNIQUE INDEX cities_lower_name_unique_key
          ON cities (lower(name))
      SQL

      direction.down { execute 'DROP INDEX cities_lower_name_unique_key' }
    end
  end
end
