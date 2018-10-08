# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DBSubscriber::Controller do
  include described_class::SpecHelper

  before do
    Thread.new { described_class.new(channels, control_channel) }
    sleep(delay)
  end

  after { notify(control_channel, '["shutdown",null]') }

  let(:control_channel) { 'control' }
  let(:delay) { 0.1 }

  context 'when a notification comes over channel' do
    let(:channels) { { 'channel' => informer } }
    let(:informer) { ->(payload) {} }

    context 'when the channel is control channel' do
      let(:channel) { control_channel }
      let(:payload) { 'payload' }

      it 'should try to parse payload' do
        expect(DBSubscriber::Payload)
          .to receive(:parse)
          .with(payload)
          .and_call_original
        notify(channel, payload)
        sleep(delay)
      end

      context 'when payload is proper' do
        let(:payload) { DBSubscriber::Payload.generate(action, param) }

        context 'when action is to subscribe' do
          let(:action) { 'subscribe' }
          let(:param) { 'something' }

          it 'should add subscription to the channel in action parameter' do
            expect(DBSubscriber::SQL::Builder)
              .to receive(:listen)
              .with(param)
              .and_call_original
            notify(channel, payload)
            sleep(delay)
          end
        end

        context 'when action is to unsubscribe' do
          let(:action) { 'unsubscribe' }
          let(:param) { 'channel' }

          it 'should remove subscription to the channel in action parameter' do
            expect(DBSubscriber::SQL::Builder)
              .to receive(:unlisten)
              .with(param)
              .and_call_original
            notify(channel, payload)
            sleep(delay)
          end
        end

        context 'when action is to shutdown' do
          let(:action) { 'shutdown' }
          let(:param) { nil }

          it 'should remove subscription to control channel' do
            expect(DBSubscriber::SQL::Builder)
              .to receive(:unlisten)
              .with(control_channel)
              .and_call_original
            notify(channel, payload)
            sleep(delay)
          end
        end

        context 'when action is to do something else' do
          let(:action) { 'do something else' }
          let(:param) { 'param' }

          it 'should ignore the notification' do
            expect(DBSubscriber::SQL::Builder).not_to receive(:listen)
            expect(DBSubscriber::SQL::Builder).not_to receive(:unlisten)
            notify(channel, payload)
            sleep(delay)
          end
        end
      end

      context 'when payload is not proper' do
        let(:payload) { 'not proper' }

        it 'should ignore the notification' do
          expect(DBSubscriber::SQL::Builder).not_to receive(:listen)
          expect(DBSubscriber::SQL::Builder).not_to receive(:unlisten)
          notify(channel, payload)
          sleep(delay)
        end
      end
    end

    context 'when the channel is not control channel' do
      let(:payload) { '123' }

      context 'when it is in the channels' do
        let(:channel) { 'channel' }

        it 'should call the handler with the notification\'s payload' do
          expect(informer).to receive(:call).with(payload).and_call_original
          notify(channel, payload)
          sleep(delay)
        end
      end

      context 'when it is not in the channels' do
        let(:channel) { 'not_in_channels' }

        it 'should ignore the notification' do
          expect(channels).not_to receive(:[]).with(channel)
          notify(channel, payload)
          sleep(delay)
        end
      end
    end
  end
end
