# frozen_string_literal: true

RSpec.describe 'Sessions REST API', type: :request do
  describe 'GET /login' do
    before { get '/login' }

    subject { response }

    it { is_expected.to have_http_status(:ok) }

    it { is_expected.to render_template('sessions/new') }
  end
end
