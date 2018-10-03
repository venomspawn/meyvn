# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events REST API', type: :request do
  describe 'POST /events', type: :request do
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
        create(:city)
        create(:topic)
        post '/events', params: params
      end

      let(:login_params) { create('params/requests/users/login') }
      let(:params) { create('params/requests/events/create', *params_traits) }
      let(:params_traits) { [] }

      context 'when parameters are correct' do
        it { is_expected.to redirect_to events_url }
      end

      context 'when parameters are of wrong structure' do
        let(:params) { { of: { wrong: :structure } } }

        it { is_expected.to have_http_status(:ok) }

        it { is_expected.to render_template(:new) }

        describe 'response body' do
          subject { response.body }

          it 'should include a message about the error' do
            expect(subject).to include('Invalid parameters')
          end
        end
      end

      context 'when parameters are of correct structure and invalid values' do
        let(:params_traits) { %i[invalid] }

        it { is_expected.to have_http_status(:ok) }

        it { is_expected.to render_template(:new) }

        describe 'response body' do
          subject { response.body }

          it 'should include a message about the error' do
            expect(subject).to include('Invalid values of parameters')
          end
        end
      end

      context 'when finish is less than start or equals it' do
        let(:params_traits) { %i[invalid_finish] }

        it { is_expected.to have_http_status(:ok) }

        it { is_expected.to render_template(:new) }

        describe 'response body' do
          subject { response.body }

          it 'should include a message about the error' do
            expect(subject)
              .to include('Finish is less than start or equals it')
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
        create(:city)
        create(:topic)
        get '/events'
      end

      let(:login_params) { create('params/requests/users/login') }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:index) }
    end
  end

  describe 'GET /events/new' do
    subject { response }

    context 'when not authorized' do
      before { get '/events/new' }

      let(:user) { {} }

      it { is_expected.to have_http_status(:found) }

      it { is_expected.to redirect_to(login_path) }
    end

    context 'when authorized' do
      before do
        post '/login', params: login_params
        create(:city)
        create(:topic)
        get '/events/new'
      end

      let(:login_params) { create('params/requests/users/login') }

      it { is_expected.to have_http_status(:ok) }

      it { is_expected.to render_template(:new) }
    end
  end
end
