# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StreamsPool do
  describe 'the class' do
    subject { described_class }

    it { is_expected.not_to respond_to(:new) }
    it { is_expected.to respond_to(:instance) }
  end

  describe '.instance' do
    subject(:result) { described_class.instance }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }

      it 'should always be the same' do
        expect(subject.object_id).to be == described_class.instance.object_id
      end
    end
  end

  describe 'instance' do
    subject { described_class.instance }

    it { is_expected.to respond_to(:include?, :register, :stream_data) }
  end

  describe '#include?' do
    subject(:result) { instance.include?(stream) }

    let(:instance) { described_class.instance }

    describe 'result' do
      subject { result }

      context 'when the stream is in the pool' do
        before { instance.register(stream, user_id) }
        after { instance.send(:remove_obj, stream) }

        let(:stream) { 'stream' }
        let(:user_id) { 'user_id' }

        it { is_expected.to be_truthy }
      end

      context 'when the stream is not in the pool' do
        let(:stream) { 'stream' }

        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#register' do
    after { instance.send(:remove_obj, stream) }

    subject { instance.register(stream, user_id) }

    let(:instance) { described_class.instance }
    let(:stream) { 'stream' }
    let(:user_id) { 'user_id' }

    it 'should add the stream to the pool' do
      expect { subject }
        .to change { instance.include?(stream) }
        .from(false)
        .to(true)
    end

    it 'should tag the stream with the user identifier' do
      expect { subject }
        .to change { instance.send(:tags_index)[:user_id]&.[](user_id) }
        .from(nil)
        .to([stream])
    end
  end

  describe '#stream_data' do
    subject { instance.stream_data(user_ids, data) }

    let(:instance) { described_class.instance }
    let(:user_ids) { [user_id] }
    let(:user_id) { 'user_id' }
    let(:data) { 'data' }

    context 'when there is stream in the pool tagged with provided user id' do
      before { instance.register(stream, user_id) }
      after { instance.send(:remove_obj, stream) }

      let(:stream) { double }

      it 'should call #write with data message' do
        allow(stream).to receive(:write)
        expect(stream).to receive(:write).with("data: #{data}\n\n")
        subject
      end

      context 'when the data is multilined' do
        let(:data) { [line1, line2].join("\n") }
        let(:line1) { 'line1' }
        let(:line2) { 'line2' }

        it 'should call #write with proper data message' do
          allow(stream).to receive(:write)
          expect(stream)
            .to receive(:write)
            .with("data: #{line1}\ndata: #{line2}\n\n")
          subject
        end
      end

      context 'when the stream raises an error with #write call' do
        before { allow(stream).to receive(:write).and_raise }

        it 'should ignore it' do
          expect { subject }.not_to raise_error
        end

        it 'should remove the stream from the pool' do
          expect { subject }
            .to change { instance.include?(stream) }
            .from(true)
            .to(false)
        end
      end
    end
  end
end
