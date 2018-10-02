# frozen_string_literal: true

FactoryBot.define do
  factory 'params/requests/sessions/login', class: Hash do
    user { create(:user) }

    skip_create
    initialize_with do
      { login: { email: user.email, password: user.password } }
    end
  end
end
