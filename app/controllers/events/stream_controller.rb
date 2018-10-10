# frozen_string_literal: true

module Events
  # Class of controllers which handle requests on streams of events creation
  # notifications
  class StreamController < ApplicationController
    include ActionController::Live

    before_action :auth

    # Associative array of headers
    HEADERS = { 'Content-Type' => 'text/event-stream' }.freeze

    # Handles GET-request with `/events/stream` path
    def stream
      set_response_headers(HEADERS)
      register
      sleep_and_ping while registered?
    rescue StandardError
      nil
    ensure
      response.stream.close
    end

    private

    # Sets headers of the response accordingly with the provided associative
    # array
    # @param [Hash] headers
    #   associative array of headers
    def set_response_headers(headers)
      headers.each { |header, value| response.headers[header] = value }
    end

    # Registers response stream in the pool
    def register
      StreamsPool.instance.register(response.stream, current_user.id)
    end

    # Returns if response stream is registered or not
    # @return [Boolean]
    #   if response stream is registered or not
    def registered?
      StreamsPool.instance.include?(response.stream)
    end

    # String with ping message
    PING_MESSAGE = "\n\n"

    # Sleep delay in seconds
    DELAY = 1

    # Sleep for {DELAY} seconds and pings connection
    def sleep_and_ping
      sleep(DELAY)
      response.stream.write(PING_MESSAGE)
    end
  end
end
