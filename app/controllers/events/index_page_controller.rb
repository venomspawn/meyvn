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
      @logic_params ||= if request.query_parameters.empty?
                          saved_filter
                        else
                          request.query_parameters
                        end
    end

    # Returns associative array of saved filter parameters
    # @return [HashWithIndifferentAccess]
    #   resulting associative array
    def saved_filter
      hash = {
        filter: {
          city_id:  current_user.filter_city_id,
          topic_id: current_user.filter_topic_id,
          start:    current_user.filter_start&.strftime('%FT%H:%M')
        }
      }
      hash.with_indifferent_access
    end

    # Returns value of `filter` parameter
    # @return [Object]
    #   resulting value
    def filter
      logic_params[:filter]
    end
  end
end
