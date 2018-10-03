# frozen_string_literal: true

module Events
  # Class of controllers which handle requests on page with events index
  class IndexPageController < ApplicationController
    before_action :auth

    # Handles GET-request with `/events` path
    def draw
      events = Logics.index(logic_params)
      render :index, locals: { events: events, filter: filter }
    end

    private

    # Returns associative array of logic parameters
    # @return [Hash]
    #   associative array of logic parameters
    def logic_params
      request.query_parameters
    end

    # Returns value of `filter` parameter
    # @return [Object]
    #   resulting value
    def filter
      logic_params[:filter]
    end
  end
end
