# frozen_string_literals: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    describe 'result' do
      subject { result }

      let(:params) { attributes_for(:user) }

      it { is_expected.to be_an_instance_of(described_class) }
      it { is_expected.to be_valid }

      context 'when email is absent' do
        let(:params) { attributes_for(:user).except(:email) }

        it { is_expected.not_to be_valid }
      end

      context 'when email is nil' do
        let(:params) { attributes_for(:user, email: nil) }

        it { is_expected.not_to be_valid }
      end

      context 'when email has wrong format' do
        let(:params) { attributes_for(:user, email: email) }
        let(:email) { 'has wrong format' }

        it { is_expected.not_to be_valid }
      end

      context 'when password is absent' do
        let(:params) { attributes_for(:user).except(:password) }

        it { is_expected.not_to be_valid }
      end

      context 'when password is nil' do
        let(:params) { attributes_for(:user, password: nil) }

        it { is_expected.not_to be_valid }
      end
    end

    context 'when email is not unique' do
      let(:params) { attributes_for(:user, email: email) }
      let(:email) { other_user.email.upcase }
      let(:other_user) { create(:user) }

      it 'should raise ActiveRecord::RecordNotUnique' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'instance' do
    subject { create(:user) }

    messages = %i[email id password password= password_digest save update]
    it { is_expected.to respond_to(*messages) }
  end

  describe '#email' do
    subject(:result) { instance.email }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      context 'when email is present' do
        it { is_expected.to be_a(String) }

        it { is_expected.to match_email_format }
      end
    end
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      context 'when id is present' do
        it { is_expected.to be_a(String) }

        it { is_expected.to match_uuid_format }
      end
    end
  end

  describe '#password' do
    subject(:result) { instance.password }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      context 'when password is present' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#password=' do
    subject { instance.password = password }

    let(:instance) { create(:user) }
    let(:password) { create(:string) }

    it 'should change password_digest' do
      expect { subject }.to change { instance.reload.password }
    end
  end

  describe '#password_digest' do
    subject(:result) { instance.password_digest }

    let(:instance) { create(:user) }

    describe 'result' do
      subject { result }

      context 'when password digest is present' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#save' do
    subject(:result) { instance.save }

    let(:instance) { build(:user) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_truthy }

      context 'when email is nil' do
        let(:instance) { build(:user, email: nil) }

        it { is_expected.to be_falsey }
      end

      context 'when email has wrong format' do
        let(:instance) { build(:user, email: email) }
        let(:email) { 'has wrong format' }

        it { is_expected.to be_falsey }
      end

      context 'when password is nil' do
        let(:instance) { build(:user, password: nil) }

        it { is_expected.to be_falsey }
      end
    end

    context 'when email is not unique' do
      let(:instance) { build(:user, email: email) }
      let(:email) { other_user.email.upcase }
      let(:other_user) { create(:user) }

      it 'should raise ActiveRecord::RecordNotUnique' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe '#update' do
    subject(:result) { instance.update(params) }

    let(:instance) { create(:user) }
    let(:params) { attributes_for(:user) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_truthy }

      context 'when email is nil' do
        let(:params) { { email: nil } }

        it { is_expected.to be_falsey }
      end

      context 'when email has wrong format' do
        let(:params) { { email: email } }
        let(:email) { 'has wrong format' }

        it { is_expected.to be_falsey }
      end

      context 'when password is nil' do
        let(:params) { { password: nil } }

        it { is_expected.to be_falsey }
      end
    end

    context 'when email is not unique' do
      let(:params) { { email: email } }
      let(:email) { other_user.email.upcase }
      let(:other_user) { create(:user) }

      it 'should raise ActiveRecord::RecordNotUnique' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
