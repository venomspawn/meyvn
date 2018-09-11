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

  private

  # Message on failed log in
  FAIL = 'Wrong email or password'

  # Adds {FAIL} alert to flash and renders log in form
  def flash_log_in_fail
    flash.now.alert = FAIL
    render :new
  end

  # Message on successful log in
  SUCCESS = 'Logged in successfully'

  # Creates session for identified and authentified user, flashes {SUCCESS}
  # notice and redirects to root path
  # @param [User] user
  #   user record
  def create_session(user)
    session[:user_id] = user.id
    redirect_to root_path, notice: SUCCESS
  end
end
