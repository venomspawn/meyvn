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
      StreamsPool.instance.register(response.stream, current_user.id)
      sleep(1) while StreamsPool.instance.include?(response.stream)
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
  end
end
