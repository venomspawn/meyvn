# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User management REST API', type: :request do
  describe 'GET /users/new' do
    before { get '/users/new' }

    subject { response }

    it { is_expected.to have_http_status(:ok) }

    it { is_expected.to render_template(:new) }
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

      it { is_expected.to redirect_to login_url }
    end

    context 'when email is of wrong format' do
      let(:email) { 'wrong format' }
      let(:password_confirmation) { password }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:new) }

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

      it { is_expected.to render_template(:new) }

      describe 'response body' do
        subject { response.body }

        it 'should include a message that email has already been taken' do
          expect(subject).to include('has already been taken')
        end
      end
    end

    context 'when password and password confirmation are different' do
      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:new) }

      describe 'response body' do
        subject { response.body }

        it 'should include a message that the confirmation doesn\'t match' do
          expect(subject).to include('doesn&#39;t match')
        end
      end
    end

    context 'when parameters are of wrong structure' do
      let(:params) { { of: %w[wrong structure] } }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:new) }

      describe 'response body' do
        subject { response.body }

        it 'should include a message about the error' do
          expect(subject).to include('Invalid parameters')
        end
      end
    end
  end

  describe 'GET /login' do
    before { get '/login' }

    subject { response }

    it { is_expected.to have_http_status(:ok) }

    it { is_expected.to render_template(:login) }
  end

  describe 'POST /login' do
    before { post '/login', params: params }

    subject { response }

    let(:params) { { login: { email: email, password: password } } }
    let(:email) { create(:email) }
    let(:password) { create(:string) }

    context 'when identification is failed' do
      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:login) }

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

      it { is_expected.to render_template(:login) }

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

      it { is_expected.to redirect_to events_url }

      it 'should set `user_id` attribute of session to user id' do
        expect(session[:user_id]).to be == user.id
      end
    end
  end

  describe 'POST /logout' do
    before { post '/logout' }

    subject { response }

    it { is_expected.to redirect_to login_url }

    it 'should set `user_id` attribute of session to `nil`' do
      expect(session[:user_id]).to be_nil
    end
  end

  describe 'POST /save_filter' do
    subject { response }

    context 'when not authorized' do
      before { post '/save_filter', params: params }

      let(:params) { {} }

      it { is_expected.to have_http_status(:found) }

      it { is_expected.to redirect_to(login_path) }
    end

    context 'when authorized' do
      before do
        post '/login', params: login_params
        create(:city)
        create(:topic)
        post '/save_filter', params: params
      end

      let(:login_params) { create('params/requests/users/login', user: user) }
      let(:user) { create(:user) }
      let(:params) { create('params/requests/users/save_filter', traits) }
      let(:traits) { { city_id: city_id, topic_id: topic_id, start: start } }
      let(:city_id) { create(:city).id }
      let(:topic_id) { create(:topic).id }
      let(:start) { time.to_s }
      let(:time) { Time.now.utc }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:index) }

      it 'should save filter to current user record' do
        subject
        user.reload
        expect(user.filter_city_id).to be == city_id
        expect(user.filter_topic_id).to be == topic_id
        expect(user.filter_start).to be_within(1).of(time)
      end

      context 'when parameters are of wrong structure' do
        let(:params) { { of: { wrong: :structure } } }

        it { is_expected.to have_http_status(:ok) }

        it { is_expected.to render_template(:index) }

        describe 'response body' do
          subject { response.body }

          it 'should include a message about the error' do
            expect(subject).to include('Invalid parameters')
          end
        end
      end

      context 'when filter values are invalid' do
        let(:city_id) { create(:uuid) }

        it { is_expected.to have_http_status(:ok) }

        it { is_expected.to render_template(:index) }

        describe 'response body' do
          subject { response.body }

          it 'should include a message about the error' do
            expect(subject).to include('Filter values are invalid')
          end
        end
      end
    end
  end
end
