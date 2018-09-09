# frozen_string_literal: true

RSpec.describe 'User management REST API', type: :request do
  describe 'GET /users/new' do
    before { get '/users/new' }

    subject { response }

    it { is_expected.to have_http_status(:ok) }

    it { is_expected.to render_template('users/new') }
  end
end
