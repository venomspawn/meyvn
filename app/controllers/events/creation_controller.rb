# frozen_string_literal: true

module Events
  # Class of controllers which handle event record creation requests
  class CreationController < ApplicationController
    before_action :auth

    # Message about invalid parameters
    INVALID_PARAMETERS = 'Invalid parameters'

    rescue_from JSON::Schema::ValidationError do |error|
      render_new_event(Event.new, INVALID_PARAMETERS)
    end

    rescue_from ActiveRecord::RecordNotSaved do |error|
      render_new_event(error.record, error.message)
    end

    # Flash message about successful creation of event record
    NOTICE = 'New event is successfully created'

    # Handles POST-request with `/events` path
    def create
      EventLogic.create(logic_params)
      redirect_to root_path, notice: NOTICE
    end

    private

    # Returns associative array of business logic parameters
    # @return [Hash]
    #   resulting associative array
    def logic_params
      request.request_parameters.dup.tap do |hash|
        hash[:creator_id] = current_user.id
      end
    end

    # Template of flash message about failed creation of event record
    ALERT_TEMPLATE = 'New event isn\'t created: %s'

    # Relative path to ERB-file of page with event creation form
    NEW_EVENT = 'events/new'

    # Renders page with event creation form, flashing alert message with event
    # creation error
    # @param [Event] event
    #   event record
    # @param [String] error_message
    #   message with event creation error
    def render_new_event(event, error_message)
      alert = format(ALERT_TEMPLATE, error_message)
      flash.now.alert = alert
      render NEW_EVENT, locals: { event: event }
    end
  end
end
