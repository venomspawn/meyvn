# frozen_string_literal: true

module Users
  # Class of controllers which handle requests on saving filter into current
  # user record
  class FilterSavingController < ApplicationController
    # Returns relative path to directory constructed from `Events` namespace
    # @return [String]
    #   resulting path
    def self.namespace_dir
      Events.to_s.downcase
    end

    self.view_paths = [views_resolver, layout_resolver]

    before_action :auth

    # Message about invalid parameters
    INVALID_PARAMETERS = 'Invalid parameters'

    rescue_from JSON::Schema::ValidationError do
      render_events_with_alert(INVALID_PARAMETERS)
    end

    rescue_from ActiveRecord::StatementInvalid do |error|
      render_events_with_alert(error.message)
    end

    # Flash message about successful creation of user record
    NOTICE = 'Filter is saved'

    # Handles POST-request with `/save_filter` path
    def save
      Logics.save_filter(logic_params)
      flash.now.notice = NOTICE
      render :index, locals: locals
    end

    private

    # Returns associative array with business logic parameters
    # @return [Hash]
    #   resulting associative array
    def logic_params
      @logic_params ||= request.request_parameters.dup.tap do |hash|
        hash[:user_id] = current_user.id
      end
    end

    # Returns value of `filter` parameter
    # @return [Object]
    #   resulting value
    def filter
      logic_params[:filter]
    end

    # Returns array of associative arrays with information on events index
    # @return [Array<Hash>]
    #   resulting array
    def events
      Events::Logics.index(logic_params)
    end

    # Returns associative array with information on local variables of view
    # rendering
    # @return [Hash]
    #   resulting associative array
    def locals
      { events: events, filter: filter }
    end

    # Template of flash message about failed filter saving
    ALERT_TEMPLATE = 'Filter isn\'t saved: %s'

    # Renders page with events index
    # @param [String] error_message
    #   message with user creation error
    def render_events_with_alert(error_message)
      flash.now.alert = format(ALERT_TEMPLATE, error_message)
      render :index, locals: locals
    end
  end
end
