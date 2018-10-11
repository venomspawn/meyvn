# frozen_string_literal: true

module Events
  module Logics
    # Class of business logic which returns information on events
    class Index < Logic
      # Returns array of assocative arrays with information on events
      # @return [Array<Hash>]
      #   resulting array
      def index
        Event.connection_pool.with_connection do |connection|
          result = connection.execute(sql.to_sql)
          result.map(&:symbolize_keys!)
        ensure
          result&.clear
        end
      end

      private

      # Empty associative array
      EMPTY = {}.freeze

      # Returns value of `filter` parameter or {EMPTY} if the value is absent
      # or `nil`
      # @return [Hash]
      #   resulting value
      def filter
        params[:filter] || EMPTY
      end

      # Returns city identifier by which the events are filtered or `nil` if
      # the identifier is absent or `nil`
      # @return [NilClass, String]
      #   resulting value
      def city_id
        filter[:city_id]
      end

      # Returns topic identifier by which the events are filtered or `nil` if
      # the identifier is absent or `nil`
      # @return [NilClass, String]
      #   resulting value
      def topic_id
        filter[:topic_id]
      end

      # String with date and time format
      TIME_FORMAT = '%FT%T'

      # Returns either string with provided date and time, if it is present and
      # correct, or string with current date and time otherwise
      # @return [String]
      #   resulting string
      def start
        Time.parse(filter[:start]).utc.strftime(TIME_FORMAT)
      rescue StandardError
        Time.now.utc.strftime(TIME_FORMAT)
      end

      # Qualified name of `events` table
      EVENTS = Event.arel_table.freeze

      # Qualified name of `title` column of `events` table aliased as
      # `event_title`
      EVENT_TITLE = EVENTS[:title].as('event_title').freeze

      # Qualified name of `place` column of `events` table aliased as
      # `event_place`
      EVENT_PLACE = EVENTS[:place].as('event_place').freeze

      # Format of string values of timestamp fields
      TIMESTAMP_FORMAT = Arel::Nodes::SqlLiteral.new('\'YYYY-MM-DD HH24:MI\'')

      # Expression to extract `start` column of `events` table aliased as
      # `event_start`
      EVENT_START =
        Arel::Nodes::NamedFunction
        .new('to_char', [EVENTS[:start], TIMESTAMP_FORMAT], 'event_start')
        .freeze

      # Expression to extract `finish` column of `events` table aliased as
      # `event_finish`
      EVENT_FINISH =
        Arel::Nodes::NamedFunction
        .new('to_char', [EVENTS[:finish], TIMESTAMP_FORMAT], 'event_finish')
        .freeze

      # Qualified name of `cities` table
      CITIES = City.arel_table.freeze

      # Qualified name of `id` column of `cities` table
      CITIES_ID = CITIES[:id]

      # Qualified name of `name` column of `cities` table aliased as
      # `city_name`
      CITY_NAME = CITIES[:name].as('city_name')

      # Qualified name of `topics` table
      TOPICS = Topic.arel_table.freeze

      # Qualified name of `id` column of `topics` table
      TOPICS_ID = TOPICS[:id]

      # Qualified name of `title` column of `topics` table aliased as
      # `topic_title`
      TOPIC_TITLE = TOPICS[:title].as('topic_title')

      # Array of expressions to select
      FIELD_EXPRESSIONS = [
        EVENT_TITLE,
        EVENT_PLACE,
        EVENT_START,
        EVENT_FINISH,
        CITY_NAME,
        TOPIC_TITLE
      ].freeze

      # Expression of joined tables
      JOINED_TABLES =
        EVENTS
        .join(CITIES)
        .on(EVENTS[:city_id].eq(CITIES_ID))
        .join(TOPICS)
        .on(EVENTS[:topic_id].eq(TOPICS_ID))
        .freeze

      # SQL statement for information extraction
      SQL =
        JOINED_TABLES
        .project(*FIELD_EXPRESSIONS)
        .order(EVENTS[:start].asc)
        .freeze

      # Returns SQL statement for information extraction
      # @return [Arel::SelectManager]
      #   resulting statement
      def sql
        conditions.reduce(SQL.dup) { |memo, condition| memo.where(condition) }
      end

      # Returns array of conditions on extraction
      # @return [Array]
      #   resulting array
      def conditions
        [EVENTS[:start].gteq(start)].tap do |array|
          array << CITIES_ID.eq(city_id) if city_id.present?
          array << TOPICS_ID.eq(topic_id) if topic_id.present?
        end
      end
    end
  end
end
