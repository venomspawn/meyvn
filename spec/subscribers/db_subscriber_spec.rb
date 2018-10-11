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

    messages =
      %i[restart started? shutdown start subscribe subscriptions? unsubscribe]
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
    subject { instance.shutdown }

    let(:instance) { described_class.instance }

    context 'when started' do
      before { instance.start }

      it 'should keep handlers' do
        expect { subject }.not_to change { instance.send(:channels).size }
      end

      it 'should notify controller to shutdown' do
        expect(described_class::SQL::Builder)
          .to receive(:unlisten)
          .at_least(:once)
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
            .at_least(:twice)
            .and_call_original
          subject
          sleep(delay)
        end
      end
    end

    context 'when shutdowned' do
      before { instance.shutdown }

      it 'should keep handlers' do
        expect { subject }.not_to change { instance.send(:channels).size }
      end

      it 'should not notify anything' do
        expect(instance).not_to receive(:notify)
        subject
      end
    end
  end

  describe '#start' do
    subject { instance.start }

    let(:instance) { described_class.instance }

    context 'when already started' do
      before { instance.start }

      it 'should do nothing' do
        expect(instance).not_to receive(:restart)
        subject
      end
    end

    context 'when shutdowned' do
      before { instance.shutdown }

      it 'should call restart' do
        expect(instance).to receive(:restart)
        subject
      end
    end
  end

  describe '#started?' do
    subject(:result) { instance.started? }

    let(:instance) { described_class.instance }

    describe 'result' do
      subject { result }

      context 'when shutdowned' do
        before { instance.shutdown }

        it { is_expected.to be_falsey }
      end

      context 'when started' do
        before { instance.start }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#subscribe' do
    subject { instance.subscribe(channel, &handler) }

    let(:instance) { described_class.instance }
    let(:channel) { 'channel' }
    let(:handler) { ->(payload) {} }

    context 'when started' do
      before do
        instance.start
        sleep(delay)
      end

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

    context 'when shutdowned' do
      before { instance.shutdown }

      it 'should add the handler' do
        subject
        expect(instance.send(:channels)['channel']).to be == handler
      end

      it 'should not notify anything' do
        expect(instance).not_to receive(:notify)
        subject
      end
    end
  end

  describe '#subscriptions?' do
    subject(:result) { instance.subscriptions? }

    let(:instance) { described_class.instance }

    describe 'result' do
      subject { result }

      context 'when a subscription was added' do
        it { is_expected.to be_truthy }
      end

      context 'when there are no subscriptions' do
        before do
          instance.send(:channels).each_key(&instance.method(:unsubscribe))
        end

        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#unsubscribe' do
    subject { instance.unsubscribe(channel) }

    let(:instance) { described_class.instance }
    let(:channel) { 'channel' }

    context 'when started' do
      before do
        instance.start
        sleep(delay)
      end

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

    context 'when shutdowned' do
      before { instance.shutdown }

      it 'should remove the handler' do
        subject
        expect(instance.send(:channels)['channel']).to be_nil
      end

      it 'should not notify anything' do
        expect(instance).not_to receive(:notify)
        subject
      end
    end
  end
end
