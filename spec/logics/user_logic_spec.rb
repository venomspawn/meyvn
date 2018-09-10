# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserLogic do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    include described_class::Create::SpecHelper

    subject(:result) { described_class.create(params) }

    let(:params) { create_params(email, password, password_confirmation) }
    let(:email) { create(:string) }
    let(:password) { create(:string) }
    let(:password_confirmation) { create(:string) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(User) }

      context 'when parameters are correct' do
        let(:email) { create(:email) }
        let(:password_confirmation) { password }

        it 'should be saved' do
          expect(result.saved_changes?).to be_truthy
        end

        describe '#errors' do
          subject { result.errors }

          it { is_expected.to be_empty }
        end
      end

      context 'when email is of wrong format' do
        let(:email) { 'wrong format' }
        let(:password_confirmation) { password }

        it 'should not be saved' do
          expect(result.saved_changes?).to be_falsey
        end

        describe '#errors' do
          subject { result.errors }

          it 'should include a message that email is invalid' do
            expect(subject.messages[:email]).to include('is invalid')
          end
        end
      end

      context 'when email has already been taken' do
        let(:email) { other_user.email.upcase }
        let(:other_user) { create(:user) }
        let(:password_confirmation) { password }

        it 'should not be saved' do
          expect(result.saved_changes?).to be_falsey
        end

        describe '#errors' do
          subject { result.errors }

          it 'should include a message that email has already been taken' do
            expect(subject.messages[:email])
              .to include('has already been taken')
          end
        end
      end

      context 'when password and password confirmation are different' do
        it 'should not be saved' do
          expect(result.saved_changes?).to be_falsey
        end

        describe '#errors' do
          subject { result.errors }

          it 'should include a message that the confirmation doesn\'t match' do
            expect(subject.messages[:password_confirmation])
              .to include('doesn\'t match Password')
          end
        end
      end
    end

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
  end
end