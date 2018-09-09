# frozen_string_literal: true

# Class of controllers which handle requests on users
class UsersController < ApplicationController
  # Handles GET-request with `/users/new` path
  def new
    user = User.new
    render :new, locals: { user: user }
  end
end
