# frozen_string_literal: true

module Users
  # Class of controllers which handle requests on page with user record
  # creation form
  class NewPageController < ApplicationController
    # Relative path to ERB-file of page with user record creation form
    NEW_ERB = 'users/new'

    # Handles GET-request with `/users/new` path
    def draw
      user = User.new
      render NEW_ERB, locals: { user: user }
    end
  end
end
