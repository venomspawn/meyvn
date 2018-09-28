# frozen_string_literal: true

module EventLogic
  # Class of business logic which returns information on events
  class Index < Base::Logic
    # Returns array of assocative arrays with information on events
    # @return [Array<Hash>]
    #   resulting array
    def index
      ActiveRecord::Base.connection.execute(sql).map(&:symbolize_keys!)
    end

    private

    # Empty associative array
    EMPTY = {}.freeze

    # Returns value of `filter` parameter or {EMPTY} if the value is absent or
    # `nil`
    # @return [Hash]
    #   resulting value
    def filter
      params[:filter] || EMPTY
    end

    # Returns city identifier by which the events are filtered or `nil` if the
    # identifier is absent or `nil`
    # @return [NilClass, String]
    #   resulting value
    def city_id
      filter[:city_id]
    end

    # Returns topic identifier by which the events are filtered or `nil` if the
    # identifier is absent or `nil`
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
    rescue
      Time.now.utc.strftime(TIME_FORMAT)
    end

    # Qualified name of `title` column of `events` table aliased as
    # `event_title`
    EVENT_TITLE = '"events"."title" AS "event_title"'

    # Qualified name of `place` column of `events` table aliased as
    # `event_place`
    EVENT_PLACE = '"events"."place" AS "event_place"'

    # Expression to extract `start` column of `events` table aliased as
    # `event_start`
    EVENT_START =
      'to_char("events"."start", \'YYYY-MM-DD HH24:MI\') AS "event_start"'

    # Expression to extract `finish` column of `events` table aliased as
    # `event_finish`
    EVENT_FINISH =
      'to_char("events"."finish", \'YYYY-MM-DD HH24:MI\') AS "event_finish"'

    # Qualified name of `name` column of `cities` table aliased as `city_name`
    CITY_NAME = '"cities"."name" AS "city_name"'

    # Qualified name of `title` column of `topics` table aliased as
    # `topic_title`
    TOPIC_TITLE = '"topics"."title" AS "topic_title"'

    # Array of expressions to select
    FIELD_EXPRESSIONS = [
      EVENT_TITLE,
      EVENT_PLACE,
      EVENT_START,
      EVENT_FINISH,
      CITY_NAME,
      TOPIC_TITLE
    ].freeze

    # String with field expressions delimeterd by colon
    FIELDS = FIELD_EXPRESSIONS.join(', ')

    # String with expression of joined tables
    JOINED_TABLES = <<-EXPRESSION.squish.freeze
      "events"
      INNER JOIN "cities" ON "events"."city_id" = "cities"."id"
      INNER JOIN "topics" ON "events"."topic_id" = "topics"."id"
    EXPRESSION

    # Template of SQL statement for information extraction
    SQL_TEMPLATE = <<-SQL_TEMPLATE.squish.freeze
      SELECT #{FIELDS} FROM #{JOINED_TABLES} WHERE %s ORDER BY "events"."start"
    SQL_TEMPLATE

    # Returns string with SQL statement for information extraction
    # @return [String]
    #   resulting string
    def sql
      format(SQL_TEMPLATE, conditions)
    end

    # Template of condition on city identifier
    CITY_ID_CONDITION_TEMPLATE = '"cities"."id" = \'%s\''

    # Returns string with condition on city identifier or `nil` if city
    # identifier is absent or `nil`
    # @return [NilClass, String]
    #   resulting value
    def city_id_condition
      city_id && format(CITY_ID_CONDITION_TEMPLATE, city_id)
    end

    # Template of condition on topic identifier
    TOPIC_ID_CONDITION_TEMPLATE = '"topics"."id" = \'%s\''

    # Returns string with condition on topic identifier or `nil` if topic
    # identifier is absent or `nil`
    # @return [NilClass, String]
    #   resulting value
    def topic_id_condition
      topic_id && format(TOPIC_ID_CONDITION_TEMPLATE, topic_id)
    end

    # Template of condition on events start date and time
    START_CONDITION_TEMPLATE = '"events"."start" >= \'%s\''

    # Returns string with condition on events start date and time
    # @return [String]
    #   resulting string
    def start_condition
      format(START_CONDITION_TEMPLATE, start)
    end

    # Returns string with conditions
    # @return [String]
    #   resulting string
    def conditions
      [start_condition, city_id_condition, topic_id_condition]
        .compact
        .join(' AND ')
    end
  end
end
