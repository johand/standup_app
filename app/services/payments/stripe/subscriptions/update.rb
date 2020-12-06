# frozen_string_literal: true

module Payments
  module Stripe
    module Subscriptions
      class Update
        include Persistence
        Result = ImmutableStruct.new(:success?, :subscription, :error)

        def initialize(params)
          @token = params[:token]
          @account = params[:account]
          @customer = {}
          @plan = params[:plan]
          @attributes = {}
          @subscription = {}
          @uuid = SecureRandom.uuid
        end

        def update
          update_stripe_subscription
        rescue ActiveRecord::RecordInvalid, ::Stripe::StripeError => e
          Result.new(
            success: false,
            subscription: subscription,
            error: e.message
          )
        end

        private

        attr_reader :customer, :account, :plan, :token, :uuid
        attr_accessor :attributes, :subscription

        def update_stripe_subscription
          load_customer
          update_subscription
          save_subscription_object
          Result.new(success: true, subscription: subscription)
        end

        def load_customer
          @customer = ::Stripe::Customer.service(
            @account.subscription.stripe_customer_id
          )

          update_source if token
        end

        def update_subscription
          subscription = ::Stripe::Subscription.retrieve(
            @account.subscription.stripe_subscription_id
          )

          @subscription = ::Stripe::Subscription.update(
            subscription.id,
            {
              cancel_at_period_end: false,
              items: [
                {
                  id: subscription&.items&.data&.first&.id,
                  plan: plan
                }
              ]
            },
            idempotency_key: uuid
          )
        end

        def update_source
          customer.save(
            { source: token },
            idempotency_key: SecureRandom.uuid
          )
        end

        def merge_token_attributes
          card = ::Stripe::Token.retrieve(token).card
          attributes.merge!(
            stripe_token: token,
            card_last4: card.last4,
            card_expiration: "#{card.exp_month}/#{card.exp_year}",
            card_type: card.brand
          )
        end
      end
    end
  end
end
