# frozen_string_literal: true

# Class of controllers which handle requests to log in and log out
class SessionsController < ApplicationController
  # Handles GET-request with `/login` path
  def new
    render :new
  end

  # Handles POST-request with `/login` path
  def create
    user = UserLogic.auth(params.to_unsafe_hash)
    if user.nil?
      flash_log_in_fail
    else
      create_session(user)
    end
  end

  # Message on successful log out
  LOGOUT_SUCCESS = 'Logged out successfully'

  # Handles POST-request with `/logout` path
  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: LOGOUT_SUCCESS
  end

  private

  # Message on failed log in
  LOGIN_FAIL = 'Wrong email or password'

  # Adds {LOGIN_FAIL} alert to flash and renders log in form
  def flash_log_in_fail
    session.delete(:user_id)
    flash.now.alert = LOGIN_FAIL
    render :new
  end

  # Message on successful log in
  LOGIN_SUCCESS = 'Logged in successfully'

  # Creates session for identified and authentified user, flashes
  # {LOGIN_SUCCESS} notice and redirects to root path
  # @param [User] user
  #   user record
  def create_session(user)
    session[:user_id] = user.id
    redirect_to root_path, notice: LOGIN_SUCCESS
  end
end
