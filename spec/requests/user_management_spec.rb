# frozen_string_literal: true

RSpec.describe 'User management REST API', type: :request do
  describe 'GET /users/new' do
    before { get '/users/new' }

    subject { response }

    it { is_expected.to have_http_status(:ok) }

    it { is_expected.to render_template('users/new') }
  end

  describe 'POST /users', type: :request do
    before { post '/users', params: params }

    subject { response }

    let(:params) { { user: user } }
    let(:user) { { email: email, password: password, **confirmation } }
    let(:confirmation) { { password_confirmation: password_confirmation } }
    let(:email) { create(:email) }
    let(:password) { create(:string) }
    let(:password_confirmation) { create(:string) }

    context 'when parameters are correct' do
      let(:email) { create(:email) }
      let(:password_confirmation) { password }

      it { is_expected.to redirect_to root_url }
    end

    context 'when email is of wrong format' do
      let(:email) { 'wrong format' }
      let(:password_confirmation) { password }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template('users/new') }

      describe 'response body' do
        subject { response.body }

        it 'should include a message that email is invalid' do
          expect(subject).to include('is invalid')
        end
      end
    end

    context 'when email has already been taken' do
      let(:email) { other_user.email.upcase }
      let(:other_user) { create(:user) }
      let(:password_confirmation) { password }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template('users/new') }

      describe 'response body' do
        subject { response.body }

        it 'should include a message that email has already been taken' do
          expect(subject).to include('has already been taken')
        end
      end
    end

    context 'when password and password confirmation are different' do
      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template('users/new') }

      describe 'response body' do
        subject { response.body }

        it 'should include a message that the confirmation doesn\'t match' do
          expect(subject).to include('doesn&#39;t match')
        end
      end
    end

    context 'when parameters are of wrong structure' do
      let(:params) { { of: %w[wrong structure] } }

      it { is_expected.to have_http_status(:unprocessable_entity) }
    end
  end
end
