# frozen_string_literal: true

module Payments
  module Stripe
    module Subscriptions
      class Create
        include Persistence
        TRAIL_DAYS = 14
        Result = ImmutableStruct.new(:success?, :subscription, :error)

        def initialize(params)
          @customer = params[:customer]
          @account = params[:account]
          @plan = params[:plan]
          @attributes = {}
          @subscription = {}
          @uuid = SecureRandom.uuid
        end

        def create
          create_stripe_subscription
        rescue ActiveRecord::RecordInvalid, ::Stripe::StripeError => e
          Result.new(
            success: false,
            subscription: subscription,
            error: e.message
          )
        else
          Result.new(success: true, subscription: subscription)
        end

        private

        attr_reader :customer, :account, :plan, :token, :uuid
        attr_accessor :attributes, :subscription

        def create_stripe_subscription
          @subscription = ::Stripe::Subscription.create(
            {
              customer: customer.is_a?(String) ? customer : customer.id,
              trial_period_days: TRAIL_DAYS,
              items: [{ plan: plan }]
            },
            idempotency_key: uuid
          )

          save_subscription_object
        end
      end
    end
  end
end
