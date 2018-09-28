# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventLogic do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:index) }
  end

  describe '.index' do
    include described_class::Index::SpecHelper

    subject(:result) { described_class.index(params) }

    describe 'result' do
      subject { result }

      let(:params) { {} }
      let!(:future_events) { create_list(:event, 2, start: Time.now + 1) }
      let(:future_titles) { future_events.map(&:title) }
      let!(:past_event) { create(:event, start: Time.now - 1) }

      it { is_expected.to match_json_schema(schema) }

      context 'when filter is absent' do
        it 'should be information on all future events' do
          expect(result.map { |hash| hash[:event_title] })
            .to match_array future_titles
        end
      end

      context 'when filter is specified' do
        let(:params) { { filter: filter } }

        context 'when filter is nil' do
          let(:filter) { nil }

          it 'should be information on all future events' do
            expect(result.map { |hash| hash[:event_title] })
              .to match_array future_titles
          end
        end

        context 'when filter isn\'t nil' do
          context 'when city identifier is specified' do
            let(:filter) { { city_id: city_id } }

            context 'when the city identifier is nil' do
              let(:city_id) { nil }

              it 'should ignore the city identifier specification' do
                expect(result.map { |hash| hash[:event_title] })
                  .to match_array future_titles
              end
            end

            context 'when the city identifier isn\'t nil' do
              let(:city_id) { future_events.first.city_id }

              it 'should be information on all events in the city' do
                expect(result.map { |hash| hash[:event_title] })
                  .to match_array [future_events.first.title]
              end
            end
          end

          context 'when topic identifier is specified' do
            let(:filter) { { topic_id: topic_id } }

            context 'when the topic identifier is nil' do
              let(:topic_id) { nil }

              it 'should ignore the topic identifier specification' do
                expect(result.map { |hash| hash[:event_title] })
                  .to match_array future_titles
              end
            end

            context 'when the topic identifier isn\'t nil' do
              let(:topic_id) { future_events.first.topic_id }

              it 'should be information on all events on the topic' do
                expect(result.map { |hash| hash[:event_title] })
                  .to match_array [future_events.first.title]
              end
            end
          end

          context 'when event start date and time are specified' do
            let(:filter) { { start: start } }

            context 'when the date and time are nil' do
              let(:start) { nil }

              it 'should be information on all future events' do
                expect(result.map { |hash| hash[:event_title] })
                  .to match_array future_titles
              end
            end

            context 'when the date and time aren\'t nil' do
              let(:start) { past_event.start.to_s }
              let(:titles) { future_titles + [past_event.title] }

              it 'should be information on all events starting from them' do
                expect(result.map { |hash| hash[:event_title] })
                  .to match_array titles
              end
            end
          end
        end
      end
    end
  end
end