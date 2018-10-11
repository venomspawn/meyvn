# frozen_string_literal: true

module Users
  # Class of controllers which handle requests on page with login form
  class LoginPageController < ApplicationController
    # Handles GET-request with `/login` path
    def draw
      render :login
    end
  end
end
