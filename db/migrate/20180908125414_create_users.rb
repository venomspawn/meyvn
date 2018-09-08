# frozen_string_literals: true

# Class of migrations which create table of users
class CreateUsers < ActiveRecord::Migration[5.2]
  # Creates or drops table of users
  def change
    create_table :users, id: :uuid, default: 'gen_random_uuid()' do |users|
      users.text :email,           null: false
      users.text :password_digest, null: false
    end

    reversible do |direction|
      direction.up do
        execute <<-SQL
          ALTER TABLE users
            ADD CONSTRAINT users_email_format_check
            CHECK (email ~ '\\A\\w+@[\\w.]+\\Z');

          CREATE UNIQUE INDEX users_lower_email_unique_key
            ON users (lower(email))
        SQL
      end

      direction.down do
        execute <<-SQL
          ALTER TABLE users DROP CONSTRAINT users_email_format_check;
          DROP INDEX users_lower_email_unique_key
        SQL
      end
    end
  end
end
