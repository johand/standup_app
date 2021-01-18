# frozen_string_literal: true

module Events
  module Stripe
    class CustomerSubscriptionDeleted
      def call(event)
        ::Payments::CustomerSubscriptionDeleted.perform_later(event.id)
      end
    end
  end
end
