# frozen_string_literal: true

# Class of controllers which handle requests on events
class EventsController < ApplicationController
  before_action :auth

  # Handles Get-request with `/events/new` path
  def new
    render :new
  end

  # Handles GET-request with `/events` path
  def index
    events = EventLogic.index(params.to_unsafe_hash)
    render :index, locals: { events: events, filter: params[:filter] }
  end
end
