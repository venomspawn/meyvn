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
# @!attribute filter_city_id
#   City identifier saved from filter of events index or `nil`, if no city
#   identifier is saved
#   @return [String, NilClass]
#     city identifier saved from filter of events index or `nil`, if no city
#     identifier is saved
# @!attribute filter_topic_id
#   Topic identifier saved from filter of events index or `nil`, if no topic
#   identifier is saved
#   @return [String, NilClass]
#     topic identifier saved from filter of events index or `nil`, if no topic
#     identifier is saved
# @!attribute filter_start
#   Date and time of event start saved from filter of events index or `nil`, if
#   no date and time are saved
#   @return [Time, NilClass]
#     date and time of event start saved from filter of events index or `nil`,
#     if no date and time are saved
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
