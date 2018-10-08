# frozen_string_literal: true

class DBSubscriber
  # Namespace of modules of functions which help to build SQL expressions
  module SQL
    # Module of functions which help to build SQL expressions
    module Builder
      # Template of SQL expression with `NOTIFY` command
      NOTIFY_SQL_TEMPLATE = 'NOTIFY %s, \'%s\''

      # Returns SQL expression with `NOTIFY` command, provided channel name,
      # and payload
      # @param [String] channel
      #   channel name
      # @param [String] payload
      #   payload
      def self.notify(channel, payload)
        format(NOTIFY_SQL_TEMPLATE, channel, payload)
      end

      # Template of SQL expression with `LISTEN` command
      LISTEN_SQL_TEMPLATE = 'LISTEN %s'

      # Returns SQL expression with `LISTEN` command and provided channel name
      # @param [String] channel
      #   channel name
      def self.listen(channel)
        format(LISTEN_SQL_TEMPLATE, channel)
      end

      # Template of SQL expression with `UNLISTEN` command
      UNLISTEN_SQL_TEMPLATE = 'UNLISTEN %s'

      # Returns SQL expression with `UNLISTEN` command and provided channel
      # name
      # @param [String] channel
      #   channel name
      def self.unlisten(channel)
        format(UNLISTEN_SQL_TEMPLATE, channel)
      end
    end
  end
end
