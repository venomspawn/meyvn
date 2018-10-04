# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email           { create(:email) }
    password        { create(:string) }
    filter_city_id  { nil }
    filter_topic_id { nil }
    filter_start    { nil }
  end
end
