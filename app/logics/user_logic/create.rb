# frozen_string_literal: true

module UserLogic
  # Class of business logic which creates new user record
  class Create < Base::Logic
    # Tries to create new user record and returns instance of {User} with
    # attributes of the record
    # @return [User]
    #   instance with attributes of the record
    def create
      User.new(creation_params).tap do |user|
        user.save
      rescue ActiveRecord::RecordNotUnique
        user.errors.add(:email, 'has already been taken')
      end
    end

    private

    # Returns associative array of new record fields
    # @return [Hash]
    #   resulting associative array
    def creation_params
      params[:user]
    end
  end
end
