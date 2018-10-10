# frozen_string_literal: true

# Class of migrations which alter table of users to add fields with information
# of stored events filter
class ChangeUsers < ActiveRecord::Migration[5.2]
  # Adds or drops fields with information of stored events filter in table of
  # users
  def change
    change_table :users do |users|
      users.belongs_to :filter_city,
                       type:        :uuid,
                       index:       true,
                       foreign_key: { to_table: :cities }

      users.belongs_to :filter_topic,
                       type:        :uuid,
                       index:       true,
                       foreign_key: { to_table: :topics}

      users.column :filter_start, :timestamp, index: true
    end
  end
end
