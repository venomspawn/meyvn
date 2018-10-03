# frozen_string_literal: true

# Base class of controller classes
class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session

  # Returns record of user with identifier stored in session or `nil` if there
  # is no stored identifier or the record can't be found
  # @return [User]
  #   record of user with identifier stored in session
  # @return [NilClass]
  #   if there is no stored identifier in session or record of user can't be
  #   found by it
  def current_user
    return @current_user if defined?(@current_user)
    user_id = session[:user_id]
    @current_user = user_id && User.find(user_id)
  end

  helper_method :current_user

  # Message about that authentication is required
  AUTH_REQUIRED = 'Authentication is required to access the page'

  # Redirects to login page if the session lacks authenticated user
  def auth
    redirect_to login_url, alert: AUTH_REQUIRED if current_user.nil?
  end

  # Returns yielded value or provided default value if an exception is raised
  # @return [Object]
  #   resulting value
  def yield_safely(default = nil)
    yield
  rescue StandardError
    default
  end

  helper_method :yield_safely
end
