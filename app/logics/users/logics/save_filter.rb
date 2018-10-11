# frozen_string_literal: true

module Users
  module Logics
    # Class of business logic which save filter of events index to user record
    class SaveFilter < Logic
      # Saves filter of events index to user record
      # @raise [ActiveRecord::RecordNotFound]
      #   if the user record can't be found
      # @raise [ActiveRecord::StatementInvalid]
      #   if the user record can't be updated
      def save
        User.connection_pool.with_connection do |connection|
          connection.transaction(requires_new: true) do
            result = connection.execute(arel.to_sql)
            raise Errors::User::NotFound if result.cmd_tuples.zero?
          rescue ActiveRecord::StatementInvalid
            raise Errors::FilterValues::Invalid
          ensure
            result&.clear
          end
        end
      end

      private

      # Returns value of `filter` parameter
      # @return [Hash]
      #   resulting value
      def filter
        params[:filter]
      end

      # Qualified name of `users` table
      USERS = User.arel_table.freeze

      # Qualified name of `id` field of `users` table
      USERS_ID = USERS[:id].freeze

      # AREL expression for user record updating
      AREL = Arel::UpdateManager.new.table(USERS).freeze

      # Returns AREL expression for user record updating
      # @return [Arel::UpdateManager]
      #   resulting expression
      def arel
        AREL.dup.where(USERS_ID.eq(params[:user_id])).set(values)
      end

      # Qualified name of `filter_city_id` field of `users` table
      USERS_FILTER_CITY_ID = USERS[:filter_city_id].freeze

      # Qualified name of `filter_topic_id` field of `users` table
      USERS_FILTER_TOPIC_ID = USERS[:filter_topic_id].freeze

      # Qualified name of `filter_start` field of `users` table
      USERS_FILTER_START = USERS[:filter_start].freeze

      # Returns associative array of fields and values to update
      # @return [Hash]
      #   resulting associative array
      def values
        {
          USERS_FILTER_CITY_ID  => filter[:city_id],
          USERS_FILTER_TOPIC_ID => filter[:topic_id],
          USERS_FILTER_START    => filter[:start]
        }
      end
    end
  end
end
