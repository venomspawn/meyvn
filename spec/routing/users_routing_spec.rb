# frozen_string_literal: true

RSpec.describe 'Routing for user management REST API', type: :routing do
  it 'routes GET /users/new to users/new_page#draw' do
    expect(get '/users/new')
      .to route_to(controller: 'users/new_page', action: 'draw')
  end

  it 'routes POST /users to users/creation#create' do
    expect(post '/users')
      .to route_to(controller: 'users/creation', action: 'create')
  end
end
