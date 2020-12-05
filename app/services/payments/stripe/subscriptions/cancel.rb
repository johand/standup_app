# frozen_string_literal: true

module Payments
  module Stripe
    module Subscriptions
      class Cancel
        Result = ImmutableStruct.new(:success?, :subscription, :error)

        def initialize(params)
          @subscription = params[:subscription]
          @uuid = SecureRandom.uuid
        end

        def cancel
          cancel_stripe_subscription
        rescue ActiveRecord::RecordInvalid, ::Stripe::StripeError => e
          Result.new(
            success: false,
            subscription: subscription,
            error: e.mesage
          )
        end

        private

        attr_reader :uuid, :subscription

        def cancel_stripe_subscription
          stripe_response = ::Stripe::Subscription.delete(subscription)

          Result.new(
            success: true,
            subscription: save_subscription(subscription, stripe_response)
          )
        end

        def save_subscription(subscription_id, stripe_response)
          ::Subscription
            .find_by(stripe_subscription_id: subscription_id)
            .update!(
              stripe_subscription_id: nil,
              plan_id: nil,
              status: stripe_response.status,
              idempotency_key: uuid
            )
        end
      end
    end
  end
end
