# frozen_string_literal: true

module Users
  # Class of controllers which handle user record creation requests
  class CreationController < ApplicationController
    rescue_from JSON::Schema::ValidationError do
      head :unprocessable_entity
    end

    # Flash message about successful creation of user account
    SUCCESS = 'User account is successfully created'

    # Template of flash message about failed creation of user account
    FAILED_TEMPLATE = 'User account isn\'t created: %s'

    # Relative path to ERB-file of page with user record creation form
    NEW_ERB = 'users/new'

    # Handles POST-request with `/users` path
    def create
      user = UserLogic.create(params.to_unsafe_hash)
      error_message = extract_error_message(user)
      if error_message.empty?
        flash.notice = SUCCESS
        redirect_to root_path
      else
        error_message = format(FAILED_TEMPLATE, error_message)
        flash.now.alert = error_message
        render NEW_ERB, locals: { user: user }
      end
    end

    private

    # Returns proper error message if there is any in the provided model
    # instance or empty string if there is none
    # @param [User] user
    #   user record
    # @return [String]
    #   resulting string
    def extract_error_message(user)
      return '' if user.errors.empty?
      field, messages = user.errors.messages.first
      field = field.to_s
      field.tr!('_', ' ')
      message = messages.first.downcase
      "#{field} #{message}"
    end
  end
end
