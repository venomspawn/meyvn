# frozen_string_literal: true

module UserLogic
  # Class of business logic which creates new user record
  class Create < Base::Logic
    # Creates new user record
    # @raise [ActiveRecord::RecordNotSaved]
    #   if the record can't be created
    def create
      User.new(creation_params).tap do |user|
        user.save!
      rescue StandardError => exception
        raise_error(user, exception)
      end
    end

    private

    # Returns associative array of new record fields
    # @return [Hash]
    #   resulting associative array
    def creation_params
      params[:user]
    end

    # Raises proper error based on the provided information on exception
    # @param [User] user
    #   user record
    # @param [Exception] exception
    #   object with information on exception
    def raise_error(user, exception)
      case exception
      when ActiveRecord::RecordInvalid
        message = user.errors.full_messages.first
        raise ActiveRecord::RecordNotSaved.new(message, user)
      when ActiveRecord::RecordNotUnique
        raise Errors::Email::AlreadyTaken, user
      else
        raise Errors::CreationParams::Invalid, user
      end
    end
  end
end
