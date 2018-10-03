# frozen_string_literal: true

module Users
  # Class of controllers which handle requests to log in
  class LoginController < ApplicationController
    rescue_from Logics::Auth::Errors::Identification::Failed do |error|
      render_login_page(error.message)
    end

    rescue_from Logics::Auth::Errors::Authentication::Failed do |error|
      render_login_page(error.message)
    end

    # Message on successful log in
    NOTICE = 'Logged in successfully'

    # Handles POST-request with `/login` path
    def login
      user = Logics.auth(request.request_parameters)
      session[:user_id] = user.id
      redirect_to root_path, notice: NOTICE
    end

    private

    # Relative path to ERB-file of page with log in form
    LOGIN_PAGE = 'users/login'

    # Sets provided error message to flash and renders page with log in form
    # @param [String] error_message
    #   error message
    def render_login_page(error_message)
      session.delete(:user_id)
      flash.now.alert = error_message
      render LOGIN_PAGE
    end
  end
end
