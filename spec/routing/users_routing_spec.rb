# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routing for user management REST API', type: :routing do
  it 'routes GET /users/new to users/new_page#draw' do
    expect(get '/users/new')
      .to route_to(controller: 'users/new_page', action: 'draw')
  end

  it 'routes POST /users to users/creation#create' do
    expect(post '/users')
      .to route_to(controller: 'users/creation', action: 'create')
  end

  it 'routes GET /login to users/login_page#draw' do
    expect(get '/login')
      .to route_to(controller: 'users/login_page', action: 'draw')
  end

  it 'routes POST /login to users/login#login' do
    expect(post '/login')
      .to route_to(controller: 'users/login', action: 'login')
  end

  it 'routes POST /logout to users/logout#logout' do
    expect(post '/logout')
      .to route_to(controller: 'users/logout', action: 'logout')
  end
end
