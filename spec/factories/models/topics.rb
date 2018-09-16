# frozen_string_literal: true

FactoryBot.define do
  factory :topic do
    title { create(:string) }
  end
end
