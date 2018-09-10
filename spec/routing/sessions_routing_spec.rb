# frozen_string_literal: true

RSpec.describe 'Routing for sessions REST API', type: :routing do
  it 'routes GET /login to sessions#new' do
    expect(get '/login').to route_to(controller: 'sessions', action: 'new')
  end
end
