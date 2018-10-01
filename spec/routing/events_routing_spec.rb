# frozen_string_literal: true

RSpec.describe 'Routing for events REST API', type: :routing do
  it 'routes POST /events to events/creation#create' do
    expect(post '/events')
      .to route_to(controller: 'events/creation', action: 'create')
  end

  it 'routes GET /events to events/index_page#draw' do
    expect(get '/events')
      .to route_to(controller: 'events/index_page', action: 'draw')
  end

  it 'routes GET /events/new to events/new_page#draw' do
    expect(get '/events/new')
      .to route_to(controller: 'events/new_page', action: 'draw')
  end
end
