# frozen_string_literal: true

module Events
  # Class of controllers which handle requests on page with event creation form
  class NewPageController < ApplicationController
    before_action :auth

    # Relative path to ERB-file of page with event creation form
    ERB = 'events/new'

    # Handles GET-request with `/events/new` path
    def draw
      event = Event.new
      render ERB, locals: { event: event }
    end
  end
end
