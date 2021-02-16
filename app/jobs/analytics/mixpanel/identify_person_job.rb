# frozen_string_literal: true

module Analytics
  module Mixpanel
    class IdentifyPersonJob < ApplicationJob
      def perform(user)
        TRACKER.people.set(user.id,
                           {
                             '$name': user.name,
                             '$email': user.email,
                             '$timezone': user.time_zone,
                             '$account_name': user.account.name,
                             '$account_plan': user.account.subscription.plan_id
                           })
      end
    end
  end
end
