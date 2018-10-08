# frozen_string_literal: true

class DBSubscriber
  class Controller
    # Module of auxiliary routines for containing class testing
    module SpecHelper
      # Executes `NOTIFY` command in new thread
      # @param [String] channel
      #   name of channel
      # @param [String] payload
      #   notification payload
      def notify(channel, payload)
        sql = SQL::Builder.notify(channel, payload)
        Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do |connection|
            connection.execute(sql).clear
          end
        end
      end
    end
  end
end
