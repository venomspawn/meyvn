# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title      { create(:string) }
    place      { create(:string) }
    start      { Time.now }
    finish     { Time.now + 3_600 }
    city_id    { create(:city).id }
    topic_id   { create(:topic).id }
    creator_id { create(:user).id }
  end
end
