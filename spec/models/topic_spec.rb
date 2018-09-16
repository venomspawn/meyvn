# frozen_string_literals: true

require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    describe 'result' do
      subject { result }

      let(:params) { attributes_for(:topic) }

      it { is_expected.to be_an_instance_of(described_class) }
      it { is_expected.to be_valid }
    end

    context 'when title is absent' do
      let(:params) { attributes_for(:topic).except(:title) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when title is nil' do
      let(:params) { attributes_for(:topic, title: nil) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when title is not unique in lower case' do
      let(:params) { attributes_for(:topic, title: title) }
      let(:title) { other_topic.title.upcase }
      let(:other_topic) { create(:topic) }

      it 'should raise ActiveRecord::RecordNotUnique' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'instance' do
    subject { create(:topic) }

    it { is_expected.to respond_to(:id, :title, :update) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:topic) }

    describe 'result' do
      subject { result }

      context 'when id is present' do
        it { is_expected.to be_a(String) }

        it { is_expected.to match_uuid_format }
      end
    end
  end

  describe '#title' do
    subject(:result) { instance.title }

    let(:instance) { create(:topic) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#update' do
    subject(:result) { instance.update(params) }

    let(:instance) { create(:topic) }
    let(:params) { attributes_for(:topic) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_truthy }
    end

    context 'when title is nil' do
      let(:params) { { title: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error(ActiveRecord::NotNullViolation)
      end
    end

    context 'when title is not unique in lower case' do
      let(:params) { { title: title } }
      let(:title) { other_topic.title.upcase }
      let(:other_topic) { create(:topic) }

      it 'should raise ActiveRecord::RecordNotUnique' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
