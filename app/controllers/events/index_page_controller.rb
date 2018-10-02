# frozen_string_literal: true

module Events
  # Class of controllers which handle requests on page with events index
  class IndexPageController < ApplicationController
    before_action :auth

    # Relative path to ERB-file of page with events index
    ERB = 'events/index'

    # Handles GET-request with `/events` path
    def draw
      events = Logics.index(params.to_unsafe_hash)
      render ERB, locals: { events: events, filter: params[:filter] }
    end
  end
end
