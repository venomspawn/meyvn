# frozen_string_literal: true

module EventLogic
  # Class of business logic which creates new event record
  class Create < Base::Logic
    # Tries to create new event record and returns instance of {Event} with
    # attributes of the record
    # @return [Event]
    #   instance with attributes of the record
    def create
      Event.new(creation_params).tap do |event|
        event.save
      rescue ActiveRecord::StatementInvalid
        event.errors.add(:finish, 'is less than start or equals it')
      end
    end

    private

    # Returns associative array of new record fields
    # @return [Hash]
    #   resulting associative array
    def creation_params
      params[:event]
    end
  end
end
