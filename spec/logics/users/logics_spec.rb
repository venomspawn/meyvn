# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Logics do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:auth, :create, :save_filter) }
  end

  describe '.auth' do
    include described_class::Auth::SpecHelper

    subject(:result) { described_class.auth(params) }

    let(:params) { create_params(email, password) }
    let(:email) { create(:email) }
    let(:password) { create(:string) }

    describe 'result' do
      subject { result }

      context 'when identification and authentication are successful' do
        let!(:user) { create(:user, email: email, password: password) }

        it { is_expected.to be_a(User) }
      end
    end

    context 'when identification is failed' do
      it 'should raise RuntimeError' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end

    context 'when authentication is failed' do
      let!(:user) { create(:user, email: email, password: create(:string)) }

      it 'should raise RuntimeError' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end

  describe '.create' do
    include described_class::Create::SpecHelper

    subject { described_class.create(params) }

    let(:params) { create_params(email, password, password_confirmation) }
    let(:email) { create(:string) }
    let(:password) { create(:string) }
    let(:password_confirmation) { create(:string) }

    context 'when parameters are correct' do
      let(:email) { create(:email) }
      let(:password_confirmation) { password }

      it 'should create new record' do
        expect { subject }.to change { User.count }.by(1)
      end
    end

    context 'when parameters are of wrong structure' do
      let(:params) { { of: %w[wrong structure] } }

      it 'should raise JSON::Schema::ValidationError' do
        expect { subject }.to raise_error(JSON::Schema::ValidationError)
      end
    end

    context 'when email is of wrong format' do
      let(:email) { 'wrong format' }
      let(:password_confirmation) { password }

      it 'should raise ActiveRecord::RecordNotSaved' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotSaved)
      end
    end

    context 'when email has already been taken' do
      let(:email) { other_user.email.upcase }
      let(:other_user) { create(:user) }
      let(:password_confirmation) { password }

      it 'should raise ActiveRecord::RecordNotSaved' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotSaved)
      end
    end

    context 'when password and password confirmation are different' do
      let(:email) { create(:email) }

      it 'should raise ActiveRecord::RecordNotSaved' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotSaved)
      end
    end
  end

  describe '.save_filter' do
    subject { described_class.save_filter(params) }

    let(:params) { create('params/logics/users/save_filter', *traits) }
    let(:traits) { [user_id: user_id] }

    context 'when user record is found' do
      let(:user_id) { user.id }
      let(:user) { create(:user) }

      context 'when city identifier is specified in filter' do
        let(:traits) { [user_id: user_id, city_id: city_id] }

        context 'when the identifier is an UUID' do
          context 'when the identifier is a primary key in cities table' do
            let(:city_id) { city.id }
            let(:city) { create(:city) }

            it 'should update `filter_city_id` field' do
              expect { subject }
                .to change { user.reload.filter_city_id }
                .to(city_id)
            end
          end

          context 'when the identifier isn\'t a primary key in cities table' do
            let(:city_id) { create(:uuid) }

            it 'should raise ActiveRecord::StatementInvalid' do
              expect { subject }
                .to raise_error(ActiveRecord::StatementInvalid)
            end
          end
        end

        context 'when the identifier isn\'t an UUID' do
          context 'when the identifier is nil' do
            let(:user) { create(:user, filter_city_id: create(:city).id) }
            let(:city_id) { nil }

            it 'should update `filter_city_id` field' do
              expect { subject }
                .to change { user.reload.filter_city_id }
                .to(nil)
            end
          end

          context 'when the identifier isn\'t nil' do
            let(:city_id) { 'isn\'t nil' }

            it 'should raise ActiveRecord::StatementInvalid' do
              expect { subject }
                .to raise_error(ActiveRecord::StatementInvalid)
            end
          end
        end
      end

      context 'when topic identifier is specified in filter' do
        let(:traits) { [user_id: user_id, topic_id: topic_id] }

        context 'when the identifier is an UUID' do
          context 'when the identifier is a primary key in topics table' do
            let(:topic_id) { topic.id }
            let(:topic) { create(:topic) }

            it 'should update `filter_topic_id` field' do
              expect { subject }
                .to change { user.reload.filter_topic_id }
                .to(topic_id)
            end
          end

          context 'when the identifier isn\'t a primary key in topics table' do
            let(:topic_id) { create(:uuid) }

            it 'should raise ActiveRecord::StatementInvalid' do
              expect { subject }
                .to raise_error(ActiveRecord::StatementInvalid)
            end
          end
        end

        context 'when the identifier isn\'t an UUID' do
          context 'when the identifier is nil' do
            let(:user) { create(:user, filter_topic_id: create(:topic).id) }
            let(:topic_id) { nil }

            it 'should update `filter_topic_id` field' do
              expect { subject }
                .to change { user.reload.filter_topic_id }
                .to(nil)
            end
          end

          context 'when the identifier isn\'t nil' do
            let(:topic_id) { 'isn\'t nil' }

            it 'should raise ActiveRecord::StatementInvalid' do
              expect { subject }
                .to raise_error(ActiveRecord::StatementInvalid)
            end
          end
        end
      end

      context 'when event start is specified in filter' do
        let(:traits) { [user_id: user_id, start: start] }

        context 'when event start is a string' do
          context 'when the string is a proper string with date and time' do
            let(:start) { time.to_s }
            let(:time) { Time.now.utc }

            it 'should update `filter_start` field' do
              subject
              expect(user.reload.filter_start).to be_within(1).of(time)
            end
          end

          context 'when the string isn\'t proper string with date and time' do
            let(:start) { 'not a proper string with date and time' }

            it 'should raise ActiveRecord::StatementInvalid' do
              expect { subject }
                .to raise_error(ActiveRecord::StatementInvalid)
            end
          end
        end

        context 'when event start is nil' do
          let(:start) { nil }

          it 'should update `filter_start` field' do
            subject
            expect(user.reload.filter_start).to be_nil
          end
        end
      end
    end

    context 'when user record isn\'t found' do
      let(:user_id) { create(:uuid) }

      it 'should raise ActiveRecord::RecordNotFound' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when parameters are of wrong structure' do
      let(:params) { { of: { wrong: :structure } } }

      it 'should raise JSON::Schema::ValidationError' do
        expect { subject }.to raise_error(JSON::Schema::ValidationError)
      end
    end
  end
end
