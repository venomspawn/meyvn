# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserLogic do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:auth, :create) }
  end

  describe '.auth' do
    include described_class::Auth::SpecHelper

    subject(:result) { described_class.auth(params) }

    let(:params) { create_params(email, password) }
    let(:email) { create(:email) }
    let(:password) { create(:string) }

    describe 'result' do
      subject { result }

      context 'when identification is failed' do
        it { is_expected.to be_nil }
      end

      context 'when authentication is failed' do
        let!(:user) { create(:user, email: email, password: create(:string)) }

        it { is_expected.to be_nil }
      end

      context 'when identification and authentication are successful' do
        let!(:user) { create(:user, email: email, password: password) }

        it { is_expected.to be_a(User) }
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
end
