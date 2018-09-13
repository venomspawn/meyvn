# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'sessions#new'

  get 'users/new' => 'users#new', as: :new_user
  post 'users' => 'users#create'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'
end
