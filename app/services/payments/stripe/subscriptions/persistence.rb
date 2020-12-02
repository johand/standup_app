# frozen_string_literal: true

module Payments
  module Stripe
    module Subscriptions
      module Persistence
        def customer_id
          customer.is_a?(String) ? customer : customer.id
        end

        def subscription_attributes
          {
            account_id: account.id,
            plan_id: plan.id,
            stripe_customer_id: customer_id,
            start: subscription.start_date,
            status: subscription.status,
            stripe_subscription_id: subscription.id,
            idempotency_key: uuid
          }
        end

        def save_subscription_object
          @attributes = subscription_attributes
          merge_token_attributes if token
          sub = ::Subscription.find_or_create_by(
            stripe_customer_id: customer_id
          )

          sub.update!(attributes)
        end
      end
    end
  end
end
