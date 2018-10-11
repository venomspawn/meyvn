# frozen_string_literal: true

FactoryBot.define do
  factory 'params/requests/events/create', class: Hash do
    event { create('params/requests/events/create#event') }

    trait :invalid_finish do
      event { create('params/requests/events/create#event', :invalid_finish) }
    end

    trait :invalid do
      event { create('params/requests/events/create#event', :invalid) }
    end

    skip_create
    initialize_with { attributes }
  end

  factory 'params/requests/events/create#event', class: Hash do
    title    { create(:string) }
    place    { create(:string) }
    start    { Time.now.strftime('%FT%H:%M') }
    finish   { Time.now.plus_with_duration(3_600).strftime('%FT%H:%M') }
    city_id  { create(:city).id }
    topic_id { create(:topic).id }

    trait :invalid_finish do
      finish { Time.now.minus_with_duration(3_600).strftime('%FT%H:%M') }
    end

    trait :invalid do
      city_id { create(:uuid) }
    end

    skip_create
    initialize_with { attributes }
  end
end
