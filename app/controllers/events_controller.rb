# frozen_string_literal: true

# Class of controllers which handle requests on events
class EventsController < ApplicationController
  before_action :auth

  # Flash message about successful creation of event record
  CREATION_SUCCESS = 'New event is successfully created'

  # Template of flash message about failed creation of event record
  CREATION_FAILED_TEMPLATE = 'New event isn\'t created: %s'

  # Handles POST-request with `/events` path
  def create
    creator_id = current_user.id
    args = params.to_unsafe_hash.tap { |hash| hash[:creator_id] = creator_id }
    event = EventLogic.create(args)
    error_message = extract_error_message(event)
    if error_message.empty?
      flash.notice = CREATION_SUCCESS
      redirect_to root_path
    else
      error_message = format(CREATION_FAILED_TEMPLATE, error_message)
      flash.now.alert = error_message
      render :new, locals: { event: event }
    end
  end

  # Handles GET-request with `/events` path
  def index
    events = EventLogic.index(params.to_unsafe_hash)
    render :index, locals: { events: events, filter: params[:filter] }
  end

  # Handles Get-request with `/events/new` path
  def new
    event = Event.new
    render :new, locals: { event: event }
  end

  private

  # Returns proper error message if there is any in the provided model instance
  # or empty string if there is none
  # @param [Event] event
  #   event record
  # @return [String]
  #   resulting string
  def extract_error_message(event)
    return '' if event.errors.empty?
    field, messages = event.errors.messages.first
    field = field.to_s
    field.tr!('_', ' ')
    message = messages.first.downcase
    "#{field} #{message}"
  end
end
