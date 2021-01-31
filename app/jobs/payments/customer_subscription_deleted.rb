# frozen_string_literal: true

module Payments
  class CustomerSubscriptionDeleted < ApplicationJob
    def perform(event)
      event = ::Stripe::Event.retrieve(event)
      subscription = obtain_subscription(event)
      subscription.update!(attributes)
    rescue NoMethodError
      logger.info "[Stripe] No subscription record found for account \
      #{event.data.object.id}"
    end

    private

    def attributes
      {
        stripe_subscription_id: nil,
        plan_id: nil,
        status: 'canceled'
      }
    end

    def obtain_subscription(event)
      subscription = event.data.object.id
      Subscription.find_by(stripe_subscription_id: subscription)
    end
  end
end
