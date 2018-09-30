# frozen_string_literal: true

RSpec.describe 'Events REST API', type: :request do
  describe 'GET /events' do
    subject { response }

    context 'when not authorized' do
      before { get '/events' }

      let(:session) { {} }

      it { is_expected.to have_http_status(:found) }

      it { is_expected.to redirect_to(login_path) }
    end

    context 'when authorized' do
      before do
        post '/login', params: params
        get '/events'
      end

      let(:params) { { login: login } }
      let(:login) { { email: user.email, password: user.password } }
      let(:user) { create(:user) }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template('events/index') }
    end
  end

  describe 'GET /events/new' do
    subject { response }

    context 'when not authorized' do
      before { get '/events/new' }

      let(:session) { {} }

      it { is_expected.to have_http_status(:found) }

      it { is_expected.to redirect_to(login_path) }
    end

    context 'when authorized' do
      before do
        post '/login', params: params
        create(:city)
        create(:topic)
        get '/events/new'
      end

      let(:params) { { login: login } }
      let(:login) { { email: user.email, password: user.password } }
      let(:user) { create(:user) }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template('events/new') }
    end
  end
end
