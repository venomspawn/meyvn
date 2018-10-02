# frozen_string_literal: true

module Sessions
  # Class of controllers which handle requests to log in
  class LoginController < ApplicationController
    # Handles POST-request with `/login` path
    def login
      user = Users::Logics.auth(params.to_unsafe_hash)
      if user.nil?
        flash_log_in_fail
      else
        create_session(user)
      end
    end

    private

    # Message on failed log in
    LOGIN_FAIL = 'Wrong email or password'

    # Relative path to ERB-file of page with log in form
    LOGIN_ERB = 'sessions/login'

    # Adds {LOGIN_FAIL} alert to flash and renders log in form
    def flash_log_in_fail
      session.delete(:user_id)
      flash.now.alert = LOGIN_FAIL
      render LOGIN_ERB
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
end
