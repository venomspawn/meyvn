# frozen_string_literal: true

FactoryBot.define do
  factory :city do
    name { create(:string) }
  end
end
