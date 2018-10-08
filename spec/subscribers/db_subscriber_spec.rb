# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DBSubscriber do
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

    messages = %i[restart shutdown start subscribe unsubscribe]
    it { is_expected.to respond_to(*messages) }
  end

  let(:delay) { 0.1 }

  describe '#restart' do
    subject { instance.restart }

    let(:instance) { described_class.instance }

    it 'should call shutdown' do
      expect(instance).to receive(:shutdown).and_call_original
      subject
    end

    it 'should create new instance of controller' do
      allow(described_class::Controller).to receive(:new)
      expect(described_class::Controller).to receive(:new)
      subject
      sleep(delay)
    end
  end

  describe '#shutdown' do
    before { instance.start }

    subject { instance.shutdown }

    let(:instance) { described_class.instance }

    it 'should remove all handlers' do
      subject
      expect(instance.send(:channels)).to be_empty
    end

    it 'should notify controller to shutdown' do
      expect(described_class::SQL::Builder)
        .to receive(:unlisten)
        .and_call_original
      subject
      sleep(delay)
    end

    context 'when there are subscriptions' do
      before { instance.subscribe(channel) {} }

      let(:channel) { 'channel' }

      it 'should notify controller to remove all of the subscriptions' do
        expect(described_class::SQL::Builder)
          .to receive(:unlisten)
          .twice
          .and_call_original
        subject
        sleep(delay)
      end
    end
  end

  describe '#start' do
    subject { instance.start }

    let(:instance) { described_class.instance }

    it 'should call shutdown' do
      expect(instance).to receive(:shutdown).and_call_original
      subject
    end

    it 'should create new instance of controller' do
      allow(described_class::Controller).to receive(:new)
      expect(described_class::Controller).to receive(:new)
      subject
      sleep(delay)
    end
  end

  describe '#subscribe' do
    before do
      instance.start
      sleep(delay)
    end

    subject { instance.subscribe(channel, &handler) }

    let(:instance) { described_class.instance }
    let(:channel) { 'channel' }
    let(:handler) { ->(payload) {} }

    it 'should add the handler' do
      subject
      expect(instance.send(:channels)['channel']).to be == handler
    end

    it 'should notify controller to subscribe' do
      expect(described_class::SQL::Builder)
        .to receive(:listen)
        .with(channel)
        .and_call_original
      subject
      sleep(delay)
    end
  end

  describe '#unsubscribe' do
    before do
      instance.start
      sleep(delay)
    end

    subject { instance.unsubscribe(channel) }

    let(:instance) { described_class.instance }
    let(:channel) { 'channel' }

    it 'should remove the handler' do
      subject
      expect(instance.send(:channels)['channel']).to be_nil
    end

    it 'should notify controller to unsubscribe' do
      expect(described_class::SQL::Builder)
        .to receive(:unlisten)
        .with(channel)
        .and_call_original
      subject
      sleep(delay)
    end
  end
end
