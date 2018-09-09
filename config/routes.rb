# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#new'

  get 'users/new' => 'users#new'
end
