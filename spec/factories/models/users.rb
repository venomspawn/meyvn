# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email    { create(:email) }
    password { create(:string) }
  end
end
