# frozen_string_literal: true

module Events
  module Logics
    # Class of business logic which creates new event record
    class Create < Logic
      # Creates new event record
      # @raise [ActiveRecord::RecordNotSaved]
      #   if the record can't be created
      def create
        Event.new(creation_params).tap do |event|
          event.save!
        rescue StandardError => exception
          raise_error(event, exception)
        end
      end

      private

      # Returns associative array of new record fields
      # @return [Hash]
      #   resulting associative array
      def creation_params
        params[:event].dup.tap { |h| h[:creator_id] = params[:creator_id] }
      end

      # Raises proper error based on the provided information on exception
      # @param [Event] event
      #   event record
      # @param [Exception] exception
      #   object with information on exception
      def raise_error(event, exception)
        raise exception if exception.instance_of?(ActiveRecord::RecordNotSaved)
        raise error(exception), event
      end

      # Returns class of errors to raise
      # @param [Exception] exception
      #   object with information on exception
      # @return [Class]
      #   class of errors to raise
      def error(exception)
        return Errors::Finish::Invalid if finish_invalid?(exception)
        Errors::CreationParams::Invalid
      end

      # Name of constraint on `start` and `finish` fields of `events` table
      CONSTRAINT_NAME = 'events_check_start_is_less_than_finish'

      # Returns if the provided exception is about violation of the constraint
      # with {CONSTRAINT_NAME} name or not
      # @param [Exception] exception
      #   object with information on exception
      # @return [Boolean]
      #   if the provided exception is about violation of the constraint with
      #   {CONSTRAINT_NAME} name or not
      def finish_invalid?(exception)
        exception.is_a?(ActiveRecord::StatementInvalid) &&
          exception.message.include?(CONSTRAINT_NAME)
      end
    end
  end
end
