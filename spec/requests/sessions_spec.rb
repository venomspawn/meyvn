# frozen_string_literal: true

RSpec.describe 'Sessions REST API', type: :request do
  describe 'GET /login' do
    before { get '/login' }

    subject { response }

    it { is_expected.to have_http_status(:ok) }

    it { is_expected.to render_template('sessions/new') }
  end

  describe 'POST /login' do
    before { post '/login', params: params }

    subject { response }

    let(:params) { { login: { email: email, password: password } } }
    let(:email) { create(:email) }
    let(:password) { create(:string) }

    context 'when identification is failed' do
      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template('sessions/new') }

      describe 'response body' do
        subject { response.body }

        it 'should include a message about wrong email or password' do
          expect(subject).to include('Wrong email or password')
        end
      end

      it 'should set `user_id` attribute of session to `nil`' do
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when authentication is failed' do
      let!(:user) { create(:user, email: email, password: create(:string)) }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template('sessions/new') }

      describe 'response body' do
        subject { response.body }

        it 'should include a message about wrong email or password' do
          expect(subject).to include('Wrong email or password')
        end
      end

      it 'should set `user_id` attribute of session to `nil`' do
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when identification and authentication are successful' do
      let(:email) { user.email }
      let(:password) { user.password }
      let(:user) { create(:user) }

      it { is_expected.to redirect_to root_url }

      it 'should set `user_id` attribute of session to user id' do
        expect(session[:user_id]).to be == user.id
      end
    end
  end

  describe 'POST /logout' do
    before { post '/logout' }

    subject { response }

    it { is_expected.to redirect_to root_url }

    it 'should set `user_id` attribute of session to `nil`' do
      expect(session[:user_id]).to be_nil
    end
  end
end
