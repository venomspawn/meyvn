# frozen_string_literal: true

module Sessions
  # Class of controllers which handle requests on page with login form
  class LoginPageController < ApplicationController
    # Relative path to ERB-file of page with log in form
    LOGIN_ERB = 'sessions/login'

    # Handles GET-request with `/login` path
    def draw
      render LOGIN_ERB
    end
  end
end
