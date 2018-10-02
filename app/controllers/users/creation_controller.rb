# frozen_string_literal: true

module Users
  # Class of controllers which handle user record creation requests
  class CreationController < ApplicationController
    # Message about invalid parameters
    INVALID_PARAMETERS = 'Invalid parameters'

    rescue_from JSON::Schema::ValidationError do |error|
      render_new_user(User.new, INVALID_PARAMETERS)
    end

    rescue_from ActiveRecord::RecordNotSaved do |error|
      render_new_user(error.record, error.message)
    end

    # Flash message about successful creation of user record
    NOTICE = 'New user is successfully signed up'

    # Handles POST-request with `/users` path
    def create
      UserLogic.create(request.request_parameters)
      redirect_to root_path, notice: NOTICE
    end

    private

    # Template of flash message about failed creation of user record
    ALERT_TEMPLATE = 'New user isn\'t signed up: %s'

    # Relative path to ERB-file of page with user creation form
    NEW_USER = 'users/new'

    # Renders page with user creation form, flashing alert message with user
    # creation error
    # @param [Event] user
    #   user record
    # @param [String] error_message
    #   message with user creation error
    def render_new_user(user, error_message)
      alert = format(ALERT_TEMPLATE, error_message)
      flash.now.alert = alert
      render NEW_USER, locals: { user: user }
    end
  end
end
