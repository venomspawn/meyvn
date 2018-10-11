# frozen_string_literal: true

module Users
  # Class of controllers which handle requests on page with user record
  # creation form
  class NewPageController < ApplicationController
    # Handles GET-request with `/users/new` path
    def draw
      user = User.new
      render :new, locals: { user: user }
    end
  end
end
