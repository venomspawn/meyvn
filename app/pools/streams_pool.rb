# frozen_string_literal: true

# Class of pools which manage stream-like objects tagged with user identifiers
class StreamsPool < Pool
  include Singleton

  # Initializes instance
  def initialize
    super
    @mutex = Thread::Mutex.new
  end

  # Returns if the stream is in the pool or not
  # @param [Object] stream
  #   stream
  # @return [Boolean]
  #   if the object is in the pool or not
  def include?(stream)
    objs_index.key?(stream)
  end

  # Adds stream in the pool and tags it with provided user identifier
  # @param [#write] stream
  #   stream-like object
  # @param [String] user_id
  #   user identifier
  def register(stream, user_id)
    sync { add_obj(stream, user_id: user_id) }
  end

  # Extracts streams by provided user identifiers and writes data in event
  # stream format
  # @param [Array] user_ids
  #   array of user identifiers
  # @param [String] data
  #   data
  def stream_data(user_ids, data)
    message = create_message(data)
    streams(user_ids).each do |stream|
      stream.write(message)
    rescue StandardError
      remove_obj(stream)
    end
  end

  private

  # Synchronization object
  # @return [Thread::Mutex]
  #   synchronization object
  attr_reader :mutex

  # Yields synchronously
  def sync
    mutex.synchronize { yield }
  end

  # String of line feed symbol
  LF = "\n"

  # String with line feed and start of data message in event stream format
  LF_DATA = "\ndata: "

  # Template of message string
  MESSAGE_TEMPLATE = "data: %s\n\n"

  # Creates message string with data in event stream format and returns the
  # string
  # @return [String]
  #   message with data in event stream format
  def create_message(data)
    data = data.gsub(LF, LF_DATA)
    format(MESSAGE_TEMPLATE, data)
  end

  # Extracts array of streams by provided user identifiers and returns it
  # @return [Array<#write>]
  #   array of streams
  def streams(user_ids)
    values = tags_index[:user_id] || NONE
    values.values_at(*user_ids).flatten
  end
end
