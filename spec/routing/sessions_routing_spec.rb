# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routing for sessions REST API', type: :routing do
  it 'routes GET /login to sessions/login_page#draw' do
    expect(get '/login')
      .to route_to(controller: 'sessions/login_page', action: 'draw')
  end

  it 'routes POST /login to sessions/login#login' do
    expect(post '/login')
      .to route_to(controller: 'sessions/login', action: 'login')
  end

  it 'routes POST /logout to sessions/logout#logout' do
    expect(post '/logout')
      .to route_to(controller: 'sessions/logout', action: 'logout')
  end
end
