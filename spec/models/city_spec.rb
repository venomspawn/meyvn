# frozen_string_literals: true

require 'rails_helper'

RSpec.describe City, type: :model do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    describe 'result' do
      subject { result }

      let(:params) { attributes_for(:city) }

      it { is_expected.to be_an_instance_of(described_class) }
      it { is_expected.to be_valid }
    end

    context 'when name is absent' do
      let(:params) { attributes_for(:city).except(:name) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when name is nil' do
      let(:params) { attributes_for(:city, name: nil) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when name is not unique in lower case' do
      let(:params) { attributes_for(:city, name: name) }
      let(:name) { other_city.name.upcase }
      let(:other_city) { create(:city) }

      it 'should raise ActiveRecord::RecordNotUnique' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'instance' do
    subject { create(:city) }

    it { is_expected.to respond_to(:id, :name, :update) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:city) }

    describe 'result' do
      subject { result }

      context 'when id is present' do
        it { is_expected.to be_a(String) }

        it { is_expected.to match_uuid_format }
      end
    end
  end

  describe '#name' do
    subject(:result) { instance.name }

    let(:instance) { create(:city) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#update' do
    subject(:result) { instance.update(params) }

    let(:instance) { create(:city) }
    let(:params) { attributes_for(:city) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_truthy }
    end

    context 'when name is nil' do
      let(:params) { { name: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    context 'when name is not unique in lower case' do
      let(:params) { { name: name } }
      let(:name) { other_city.name.upcase }
      let(:other_city) { create(:city) }

      it 'should raise ActiveRecord::RecordNotUnique' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
