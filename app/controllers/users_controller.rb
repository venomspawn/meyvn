# frozen_string_literal: true

# Class of controllers which handle requests on users
class UsersController < ApplicationController
  rescue_from JSON::Schema::ValidationError do
    head :unprocessable_entity
  end

  # Handles GET-request with `/users/new` path
  def new
    user = User.new
    render :new, locals: { user: user }
  end

  # Flash message about successful creation of user account
  CREATION_SUCCESS = 'User account is successfully created'

  # Template of flash message about failed creation of user account
  CREATION_FAILED_TEMPLATE = 'User account isn\'t created: %s'

  # Handles POST-request with `/users` path
  def create
    user = UserLogic.create(params.to_unsafe_hash)
    error_message = extract_error_message(user)
    if error_message.empty?
      flash.notice = CREATION_SUCCESS
      redirect_to root_path
    else
      error_message = format(CREATION_FAILED_TEMPLATE, error_message)
      flash.now.alert = error_message
      render :new, locals: { user: user }
    end
  end

  private

  # Returns proper error message if there is any in the provided model instance
  # or empty string if there is none
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
