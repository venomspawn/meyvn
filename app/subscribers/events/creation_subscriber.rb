# frozen_string_literal: true

module Events
  # Class of subscribers on notifications of event creations
  class CreationSubscriber
    # Handles notification of event creation
    # @param [String] payload
    #   notification payload
    def self.handle(payload)
      new(payload).handle
    end

    # Procedure which handles notifications of event creations
    HANDLER = method(:handle).to_proc

    # Name of channel to subscribe
    CHANNEL = 'events_creation'

    # Subscribes on channel of notifications of event creations
    def self.subscribe
      DBSubscriber.instance.subscribe(CHANNEL, &HANDLER)
    end

    # Initializes instance
    # @param [String] payload
    #   notification payload
    def initialize(payload)
      @payload = payload.to_s
    end

    # Handles notification of event creation in the following way:
    #
    # *   extracts identifiers of user records with saved filters which satisfy
    #     event data;
    # *   sends event data via streams tagged with the identifiers in
    #     {StreamsPool}.
    #
    # Ignores errors.
    def handle
      user_ids = extract_user_ids
      return if user_ids.blank?
      StreamsPool.instance.stream_data(user_ids, sanitized_payload)
    rescue StandardError
      nil
    end

    private

    # Notification payload
    # @return [String]
    #   notification payload
    attr_reader :payload

    # Returns JSON-string of payload with sanitized values
    # @return [String]
    #   resulting JSON-string
    def sanitized_payload
      sanitized_event = event.dup
      sanitize_time(sanitized_event, :event_start)
      sanitize_time(sanitized_event, :event_finish)
      sanitized_event.to_json
    end

    # Date and time format for values of event start and finish
    TIME_FORMAT = '%F %H:%M'

    # Extracts, parses, and adjusts format to {TIME_FORMAT} of value in the
    # provided associative array with provided key. Does nothing if an error
    # appears.
    # @param [Hash] hash
    #   associative array
    # @param [Object] key
    #   key
    def sanitize_time(hash, key)
      value = hash[key]
      value = Time.parse(value)
      hash[key] = value.strftime(TIME_FORMAT)
    rescue StandardError
      nil
    end

    # Returns associative array of created event data recovered from
    # JSON-string of {payload}
    # @return [Hash{Symbol => Object}]
    #   associative array of event data
    def event
      @event ||= JSON.parse(payload, symbolize_names: true)
    end

    # Returns value of `event_start` field in {event}
    # @return [Object]
    #   value of `event_start` field in {event}
    def start
      event[:event_start]
    end

    # Returns value of `city_id` field in {event}
    # @return [Object]
    #   value of `city_id` field in {event}
    def city_id
      event[:city_id]
    end

    # Returns value of `topic_id` field in {event}
    # @return [Object]
    #   value of `topic_id` field in {event}
    def topic_id
      event[:topic_id]
    end

    # Extracts and returns array of identifiers of user records, filters of
    # which satisfy event data. Returns empty array if any error appears.
    # @return [Array<String>]
    #   resulting array
    def extract_user_ids
      User.connection_pool.with_connection do |connection|
        result = connection.execute(user_ids_arel.to_sql)
        result.ntuples.times.map { |i| result.getvalue(i, 0) }
      ensure
        result&.clear
      end
    end

    # Qualified name of `users` table
    USERS = User.arel_table.freeze

    # Qualified name of `id` field of `users` table
    USERS_ID = USERS[:id].freeze

    # Expression to select identifiers of user records
    SELECT_USERS_ID = USERS.project(USERS_ID).freeze

    # Returns AREL expression to select identifiers of user records, filters of
    # which satisfy event data
    # @return [Arel::SelectManager]
    #   resulting AREL expression
    def user_ids_arel
      SELECT_USERS_ID
        .dup
        .where(users_filter_city_id_condition)
        .where(users_filter_topic_id_condition)
        .where(users_filter_start_condition)
    end

    # Qualified name of `filter_city_id` name of `users` table
    USERS_FILTER_CITY_ID = USERS[:filter_city_id].freeze

    # Expression to check if values of `filter_city_id` of `users` table are
    # `NULL`
    USERS_FILTER_CITY_ID_IS_NULL = USERS_FILTER_CITY_ID.eq(nil).freeze

    # Returns condition on `filter_city_id` field of `users` table
    # @return [Arel::Nodes::NodeExpression]
    #   resulting condition
    def users_filter_city_id_condition
      USERS_FILTER_CITY_ID.eq(city_id).or(USERS_FILTER_CITY_ID_IS_NULL)
    end

    # Qualified name of `filter_topic_id` name of `users` table
    USERS_FILTER_TOPIC_ID = USERS[:filter_topic_id].freeze

    # Expression to check if values of `filter_topic_id` of `users` table are
    # `NULL`
    USERS_FILTER_TOPIC_ID_IS_NULL = USERS_FILTER_TOPIC_ID.eq(nil).freeze

    # Returns condition on `filter_topic_id` field of `users` table
    # @return [Arel::Nodes::NodeExpression]
    #   resulting condition
    def users_filter_topic_id_condition
      USERS_FILTER_TOPIC_ID.eq(topic_id).or(USERS_FILTER_TOPIC_ID_IS_NULL)
    end

    # Qualified name of `filter_start` name of `users` table
    USERS_FILTER_START = USERS[:filter_start].freeze

    # Expression to check if values of `filter_start` of `users` table are
    # `NULL`
    USERS_FILTER_START_IS_NULL = USERS_FILTER_START.eq(nil).freeze

    # Returns condition on `filter_start` field of `users` table
    # @return [Arel::Nodes::NodeExpression]
    #   resulting condition
    def users_filter_start_condition
      USERS_FILTER_START.lteq(start).or(USERS_FILTER_START_IS_NULL)
    end
  end
end
