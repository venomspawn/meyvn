# frozen_string_literal: true

RSpec.describe 'Routing for events REST API', type: :routing do
  it 'routes GET /events to events#index' do
    expect(get '/events').to route_to(controller: 'events', action: 'index')
  end
end
