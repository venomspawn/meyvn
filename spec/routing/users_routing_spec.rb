# frozen_string_literal: true

RSpec.describe 'Routing for user mangement REST API', type: :routing do
  it 'routes GET /users/new to users#new' do
    expect(get '/users/new').to route_to(controller: 'users', action: 'new')
  end
end
