# frozen_string_literal: true

module Users
  # Class of controllers which handle requests to log out
  class LogoutController < ApplicationController
    # Message on successful log out
    NOTICE = 'Logged out successfully'

    # Handles POST-request with `/logout` path
    def logout
      session.delete(:user_id)
      redirect_to login_url, notice: NOTICE
    end
  end
end
