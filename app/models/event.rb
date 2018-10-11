# frozen_string_literal: true

# Model of event
# @!attribute id
#   Identifier of record in UUID format
#   @return [String]
#     identifier of record in UUID format
# @!attribute title
#   Title
#   @return [String]
#     title
# @!attribute place
#   Place description
#   @return [String]
#     place description
# @!attribute start
#   Date and time of start
#   @return [Time]
#     date and time of start
# @!attribute finish
#   Date and time of finish
#   @return [Time]
#     date and time of finish
# @!attribute city_id
#   Identifier of city record
#   @return [String]
#     identifier of city record
# @!attribute topic_id
#   Identifier of topic record
#   @return [String]
#     identifier of topic record
# @!attribute creator_id
#   Identifier of user record
#   @return [String]
#     identifier of user record
class Event < ApplicationRecord
end
