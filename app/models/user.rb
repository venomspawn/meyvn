# frozen_string_literal: true

# Model of user
# @!attribute id
#   Identifier of record in UUID format
#   @return [String]
#     identifier of record in UUID format
# @!attribute email
#   E-mail
#   @return [String]
#     e-mail
# @!attribute password_digest
#   Digest of password
#   @return [String]
#     digest of password
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
