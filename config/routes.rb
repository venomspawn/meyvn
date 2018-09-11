# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#new'

  get 'users/new' => 'users#new'
  post 'users' => 'users#create'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
end
