# frozen_string_literal

module EventLogic
  class Create
    # Provides auxiliary methods to tests of containing class
    module SpecHelper
      # Returns associative array of business logic parameters
      # @param [Boolean] correct
      #   should finish date and time be more than start date and time or not
      # @return [ActiveSupport::HashWithIndifferentAccess]
      #   resulting associative array
      def create_params(correct = true)
        start = Time.now
        finish = correct ? start + 86_400 : start - 86_400
        params = {
          event: {
            title:      FactoryBot.create(:string),
            place:      FactoryBot.create(:string),
            start:      start.strftime('%FT%H:%M'),
            finish:     finish.strftime('%FT%H:%M'),
            city_id:    FactoryBot.create(:city).id,
            topic_id:   FactoryBot.create(:topic).id,
            creator_id: FactoryBot.create(:user).id,
          }
        }
        params.with_indifferent_access
      end
    end
  end
end
