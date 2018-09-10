# frozen_string_literal: true

# Class of controllers which handle requests to log in and log out
class SessionsController < ApplicationController
  # Handles GET-request with `/login` path
  def new
    render :new
  end
end
