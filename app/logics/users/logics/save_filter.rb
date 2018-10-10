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
        User.transaction(requires_new: true) do
          result = connection.execute(update_sql)
          raise Errors::User::NotFound if result.cmd_tuples.zero?
        rescue ActiveRecord::StatementInvalid
          raise Errors::FilterValues::Invalid
        ensure
          result&.clear
        end
      end

      private

      # Returns connection with database
      # @return [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter]
      #   the connection
      def connection
        @connection ||= User.connection
      end

      # Returns value of `filter` parameter
      # @return [Hash]
      #   resulting value
      def filter
        params[:filter]
      end

      # Template of single quoted expression
      QUOTED_TEMPLATE = '\'%s\''

      # Expression for `NULL`
      NULL = 'NULL'

      # Returns either {NULL}, if provided value is `nil`, or quoted string
      # ready to use in SQL expression otherwise
      # @return [String]
      #   resulting string
      def string_sql(value)
        return NULL if value.blank?
        value = connection.quote_string(value)
        format(QUOTED_TEMPLATE, value)
      end

      # Returns associative array with values to substitute into
      # {UPDATE_SQL_TEMPLATE}
      # @return [Hash]
      #   resulting associative array
      def update_sql_template_params
        {
          filter_city_id:  string_sql(filter[:city_id]),
          filter_topic_id: string_sql(filter[:topic_id]),
          filter_start:    string_sql(filter[:start]),
          user_id:         string_sql(params[:user_id])
        }
      end

      # Template of SQL expression for user record updating
      UPDATE_SQL_TEMPLATE = <<-TEMPLATE.squish.freeze
        UPDATE "users"
          SET "filter_city_id"  = %<filter_city_id>s,
              "filter_topic_id" = %<filter_topic_id>s,
              "filter_start"    = %<filter_start>s
          WHERE "id" = %<user_id>s
      TEMPLATE

      # Returns SQL expression for user record updating
      # @return [String]
      #  resulting expression
      def update_sql
        format(UPDATE_SQL_TEMPLATE, update_sql_template_params)
      end
    end
  end
end
