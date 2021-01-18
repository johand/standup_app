# frozen_string_literal: true

module Events
  module Stripe
    class CustomerSubscriptionTrialWillEnd
      def call(event)
        ::Payments::CustomerSubscriptionTrialWillEnd.email(event.id).deliver_later
      end
    end
  end
end
