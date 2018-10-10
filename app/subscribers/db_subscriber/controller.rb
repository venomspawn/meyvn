# frozen_string_literal: true

class DBSubscriber
  # Class of controllers which listen connections with database and process
  # incoming messages
  class Controller
    # Initializes instance of the class and starts main loop
    # @param [Hash{String => Proc}] channels
    #   reference to associative array with channel names as keys and message
    #   handlers as values
    # @param [String] control_channel
    #   name of control channel
    def initialize(channels, control_channel)
      @channels = channels
      @control_channel = control_channel
      @connection = extract_connection

      channels.each_key(&method(:subscribe))
      subscribe(control_channel)
      run_main_loop

      ActiveRecord::Base.clear_active_connections!
    end

    private

    # Reference to associative array with channel names as keys and message
    # handlers as values
    # @return [Hash{String => Proc}]
    #   reference to associative array with channel names as keys and message
    #   handlers as values
    attr_reader :channels

    # Name of control channel
    # @return [String]
    #   name of control channel
    attr_reader :control_channel

    # Connection to database
    # @return [PG::Connection]
    #   connection to database
    attr_reader :connection

    # Returns connection to database
    # @return [PG::Connection]
    #   connection to database
    def extract_connection
      ActiveRecord::Base.connection.instance_variable_get(:@connection)
    end

    # Executes SQL command ignoring errors and manually clearing result of the
    # execution
    # @param [String] sql
    #   SQL command
    def exec_sql(sql)
      result = connection.async_exec(sql)
    rescue StandardError
      nil
    ensure
      result&.clear
    end

    # Adds subscription on channel with provided name
    # @param [String] channel
    #   name of the channel
    def subscribe(channel)
      sql = SQL::Builder.listen(channel)
      exec_sql(sql)
    end

    # Removes subscription on channel with provided name
    # @param [String] channel
    #   name of the channel
    def unsubscribe(channel)
      sql = SQL::Builder.unlisten(channel)
      exec_sql(sql)
    end

    # Waits for incoming notifications in endless loop until shutdown command
    def run_main_loop
      loop do
        connection.wait_for_notify do |channel, _, payload|
          next inform(channel, payload) unless channel == control_channel
          action, = execute(payload)
          return action if action == :shutdown
        end
      end
    end

    # Executes procedure, which corresponds to provided channel name, with
    # provided payload, ignoring errors
    # @param [String] channel
    #   name of channel
    # @param [String] payload
    #   payload
    def inform(channel, payload)
      channels[channel].call(payload)
    rescue StandardError
      nil
    end

    # Parses payload, extracts action name and its parameter, executes the
    # action and returns array of action name and the parameter
    # @param [String] payload
    #   message payload
    # @return [Array<(Symbol, String)>]
    #   array of action name and its parameter
    def execute(payload)
      Payload.parse(payload).tap do |action, channel|
        case action
        when :subscribe   then subscribe(channel)
        when :unsubscribe then unsubscribe(channel)
        when :shutdown    then unsubscribe(control_channel)
        end
      end
    end
  end
end
