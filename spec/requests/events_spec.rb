# frozen_string_literal: true

RSpec.describe 'Events REST API', type: :request do
  describe 'POST /events', type: :request do
    before { post '/events', params: params }

    subject { response }

    context 'when not authorized' do
      before { post '/events', params: params }

      let(:params) { {} }

      it { is_expected.to have_http_status(:found) }

      it { is_expected.to redirect_to(login_path) }
    end

    context 'when authorized' do
      before do
        post '/login', params: login_params
        post '/events', params: params
      end

      let(:login_params) { { login: login } }
      let(:login) { { email: user.email, password: user.password } }
      let(:user) { create(:user) }
      let(:params) { { event: event } }
      let(:event) { attributes_for(:event, *traits).except(:creator_id) }
      let(:traits) { [] }

      context 'when parameters are correct' do
        it { is_expected.to redirect_to root_url }
      end

      context 'when finish is less than start or equals it' do
        let(:traits) { [start: start, finish: finish] }
        let(:start) { Time.now.strftime('%FT%H:%M') }
        let(:finish) { (Time.now - 86_400).strftime('%FT%H:%M') }

        it { is_expected.to have_http_status(:ok) }

        it { is_expected.to render_template('events/new') }

        describe 'response body' do
          subject { response.body }

          it 'should include a message about the error' do
            expect(subject).to include('is less than start or equals it')
          end
        end
      end
    end
  end

  describe 'GET /events' do
    subject { response }

    context 'when not authorized' do
      before { get '/events' }

      it { is_expected.to have_http_status(:found) }

      it { is_expected.to redirect_to(login_path) }
    end

    context 'when authorized' do
      before do
        post '/login', params: login_params
        get '/events'
      end

      let(:login_params) { { login: login } }
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
