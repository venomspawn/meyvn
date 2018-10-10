# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    describe 'result' do
      subject { result }

      let(:params) { attributes_for(:event) }

      it { is_expected.to be_an_instance_of(described_class) }
      it { is_expected.to be_valid }
    end

    context 'when title is absent' do
      let(:params) { attributes_for(:event).except(:title) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when title is nil' do
      let(:params) { attributes_for(:event, title: nil) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when place is absent' do
      let(:params) { attributes_for(:event).except(:place) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when place is nil' do
      let(:params) { attributes_for(:event, place: nil) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when start is absent' do
      let(:params) { attributes_for(:event).except(:start) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when start is nil' do
      let(:params) { attributes_for(:event, start: nil) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when start is a string' do
      let(:params) { attributes_for(:event, start: string) }

      context 'when the string is not a representation of date and time' do
        let(:string) { 'not a representation of date and time' }

        it 'should raise ActiveRecord::NotNullViolation' do
          expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
        end
      end
    end

    context 'when finish is absent' do
      let(:params) { attributes_for(:event).except(:finish) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when finish is nil' do
      let(:params) { attributes_for(:event, finish: nil) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when finish is a string' do
      let(:params) { attributes_for(:event, finish: string) }

      context 'when the string is not a representation of date and time' do
        let(:string) { 'not a representation of date and time' }

        it 'should raise ActiveRecord::NotNullViolation' do
          expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
        end
      end
    end

    context 'when finish is less than start' do
      let(:params) { attributes_for(:event, start: start, finish: finish) }
      let(:start) { Time.now }
      let(:finish) { start - 1 }

      it 'should raise ActiveRecord::StatementInvalid' do
        expect { subject }.to raise_error { ActiveRecord::StatementInvalid }
      end
    end

    context 'when city identifier is absent' do
      let(:params) { attributes_for(:event).except(:city_id) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when city identifier is nil' do
      let(:params) { attributes_for(:event, city_id: nil) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when city identifier is not an UUID' do
      let(:params) { attributes_for(:event, city_id: 'not an UUID') }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when city identifier is an UUID' do
      let(:params) { attributes_for(:event, city_id: uuid) }

      context 'when the UUID is not primary key of a row in cities table' do
        let(:uuid) { SecureRandom.uuid }

        it 'should raise ActiveRecord::InvalidForeignKey' do
          expect { subject }.to raise_error { ActiveRecord::InvalidForeignKey }
        end
      end
    end

    context 'when topic identifier is absent' do
      let(:params) { attributes_for(:event).except(:topic_id) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when topic identifier is nil' do
      let(:params) { attributes_for(:event, topic_id: nil) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when topic identifier is not an UUID' do
      let(:params) { attributes_for(:event, topic_id: 'not an UUID') }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when topic identifier is an UUID' do
      let(:params) { attributes_for(:event, topic_id: uuid) }

      context 'when the UUID is not primary key of a row in cities table' do
        let(:uuid) { SecureRandom.uuid }

        it 'should raise ActiveRecord::InvalidForeignKey' do
          expect { subject }.to raise_error { ActiveRecord::InvalidForeignKey }
        end
      end
    end

    context 'when creator identifier is absent' do
      let(:params) { attributes_for(:event).except(:creator_id) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when creator identifier is nil' do
      let(:params) { attributes_for(:event, creator_id: nil) }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when creator identifier is not an UUID' do
      let(:params) { attributes_for(:event, creator_id: 'not an UUID') }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when creator identifier is an UUID' do
      let(:params) { attributes_for(:event, creator_id: uuid) }

      context 'when the UUID is not primary key of a row in cities table' do
        let(:uuid) { SecureRandom.uuid }

        it 'should raise ActiveRecord::InvalidForeignKey' do
          expect { subject }.to raise_error { ActiveRecord::InvalidForeignKey }
        end
      end
    end
  end

  describe 'instance' do
    subject { create(:event) }

    messages = %i[
      city_id
      creator_id
      finish
      id
      place
      start
      title
      topic_id
      update
    ]
    it { is_expected.to respond_to(:id, :title, :update) }
  end

  describe '#city_id' do
    subject(:result) { instance.city_id }

    let(:instance) { create(:event) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it { is_expected.to match_uuid_format }

      it 'should be primary key of a row in cities table' do
        expect(City.find(result)).not_to be_nil
      end
    end
  end

  describe '#creator_id' do
    subject(:result) { instance.creator_id }

    let(:instance) { create(:event) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it { is_expected.to match_uuid_format }

      it 'should be primary key of a row in users table' do
        expect(User.find(result)).not_to be_nil
      end
    end
  end

  describe '#finish' do
    subject(:result) { instance.finish }

    let(:instance) { create(:event) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(ActiveSupport::TimeWithZone) }

      it 'should be greater than start' do
        expect(result).to be >= instance.start
      end
    end
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:event) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it { is_expected.to match_uuid_format }
    end
  end

  describe '#place' do
    subject(:result) { instance.place }

    let(:instance) { create(:event) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#start' do
    subject(:result) { instance.start }

    let(:instance) { create(:event) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(ActiveSupport::TimeWithZone) }

      it 'should be less than finish' do
        expect(result).to be < instance.finish
      end
    end
  end

  describe '#title' do
    subject(:result) { instance.title }

    let(:instance) { create(:event) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#topic_id' do
    subject(:result) { instance.topic_id }

    let(:instance) { create(:event) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it { is_expected.to match_uuid_format }

      it 'should be primary key of a row in topics table' do
        expect(Topic.find(result)).not_to be_nil
      end
    end
  end

  describe '#update' do
    subject(:result) { instance.update(params) }

    let(:instance) { create(:event) }
    let(:params) { attributes_for(:event) }

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

    context 'when place is nil' do
      let(:params) { { place: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when start is nil' do
      let(:params) { { start: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when start is a string' do
      let(:params) { { start: string } }

      context 'when the string is not a representation of date and time' do
        let(:string) { 'not a representation of date and time' }

        it 'should raise ActiveRecord::NotNullViolation' do
          expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
        end
      end
    end

    context 'when start is greater than finish' do
      let(:params) { { start: start } }
      let(:finish) { instance.finish + 1 }

      it 'should raise ActiveRecord::StatementInvalid' do
        expect { subject }.to raise_error { ActiveRecord::StatementInvalid }
      end
    end

    context 'when finish is nil' do
      let(:params) { { finish: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when finish is a string' do
      let(:params) { { finish: string } }

      context 'when the string is not a representation of date and time' do
        let(:string) { 'not a representation of date and time' }

        it 'should raise ActiveRecord::NotNullViolation' do
          expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
        end
      end
    end

    context 'when finish is less than start' do
      let(:params) { { finish: finish } }
      let(:finish) { instance.start - 1 }

      it 'should raise ActiveRecord::StatementInvalid' do
        expect { subject }.to raise_error { ActiveRecord::StatementInvalid }
      end
    end

    context 'when city identifier is nil' do
      let(:params) { { city_id: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when city identifier is not an UUID' do
      let(:params) { { city_id: 'not an UUID' } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when city identifier is an UUID' do
      let(:params) { { city_id: uuid } }

      context 'when the UUID is not primary key of a row in cities table' do
        let(:uuid) { SecureRandom.uuid }

        it 'should raise ActiveRecord::InvalidForeignKey' do
          expect { subject }.to raise_error { ActiveRecord::InvalidForeignKey }
        end
      end
    end

    context 'when topic identifier is nil' do
      let(:params) { { topic_id: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when topic identifier is not an UUID' do
      let(:params) { { topic_id: 'not an UUID' } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when topic identifier is an UUID' do
      let(:params) { { topic_id: uuid } }

      context 'when the UUID is not primary key of a row in cities table' do
        let(:uuid) { SecureRandom.uuid }

        it 'should raise ActiveRecord::InvalidForeignKey' do
          expect { subject }.to raise_error { ActiveRecord::InvalidForeignKey }
        end
      end
    end

    context 'when creator identifier is nil' do
      let(:params) { { creator_id: nil } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when creator identifier is not an UUID' do
      let(:params) { { creator_id: 'not an UUID' } }

      it 'should raise ActiveRecord::NotNullViolation' do
        expect { subject }.to raise_error { ActiveRecord::NotNullViolation }
      end
    end

    context 'when creator identifier is an UUID' do
      let(:params) { { creator_id: uuid } }

      context 'when the UUID is not primary key of a row in cities table' do
        let(:uuid) { SecureRandom.uuid }

        it 'should raise ActiveRecord::InvalidForeignKey' do
          expect { subject }.to raise_error { ActiveRecord::InvalidForeignKey }
        end
      end
    end
  end
end
