# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::CreationSubscriber do
  describe 'the class' do
    subject { described_class }

    it { is_expected.to respond_to(:handle, :subscribe) }
  end

  describe '.handle' do
    subject { described_class.handle(payload) }

    let(:payload) { event.to_json }
    let(:event) { { event_start: time } }
    let(:time) { Time.now }
    let(:sanitized_payload) { { event_start: sanitized_time }.to_json }
    let(:sanitized_time) { time.strftime('%F %H:%M') }
    let(:user) { create(:user) }

    it 'should send payload to streams tagged with user identifiers' do
      expect(StreamsPool.instance)
        .to receive(:stream_data)
        .with([user.id], sanitized_payload)
      subject
    end

    context 'when saved user filters don\'t satisfy event data' do
      let!(:user) { create(:user, filter_start: Time.now + 86_400) }
      let(:other_user) { create(:user) }

      it 'shouldn\'t send payload to streams tagged with the identifiers' do
        expect(StreamsPool.instance)
          .to receive(:stream_data)
          .with([other_user.id], sanitized_payload)
        subject
      end
    end

    context 'when the payload is not a JSON-string' do
      let(:payload) { 'not a JSON-string' }

      it 'shouldn\'t send payload' do
        expect(StreamsPool.instance).not_to receive(:stream_data)
        subject
      end
    end

    context 'when an error appears during handling' do
      before { allow(User).to receive(:connection_pool).and_raise }

      it 'shouldn\'t send payload' do
        expect(StreamsPool.instance).not_to receive(:stream_data)
        subject
      end
    end
  end

  describe '.subscribe' do
    subject { described_class.subscribe }

    it 'should subscribe on events creation channel' do
      expect(DBSubscriber.instance)
        .to receive(:subscribe)
        .with('events_creation')
        .and_call_original
      subject
    end
  end
end
