# frozen_string_literal: true

module Payments
  module Stripe
    module Card
      class Create
        Result = ImmutableStruct.new(:success?, :subscription, :error)

        def initialize(params)
          @token = params[:token]
          @account = params[:account]
          @card = {}
          @uuid = SecureRandom.uuid
        end

        def create
          create_card
        rescue ActiveRecord::RecordInvalid, ::Stripe::StripeError => e
          Result.new(
            sucess: false,
            error: e.message
          )
        end

        private

        attr_reader :account, :token, :uuid
        attr_accessor :card

        def create_card
          ::Stripe::Customer.update(
            account.subscription.stripe_customer_id,
            { source: token },
            idempotency_key: uuid
          )

          update_subscription
          Result.new(success: true, subscription: account.subscription)
        end

        def update_subscription
          card = ::Stripe::Token.retrieve(token).card
          account.subscription.tap do |sub|
            sub.stripe_token = card.id
            sub.card_last4 = card.last4
            sub.card_expiration = "#{card.exp_mont}/#{card.exp_year}"
            sub.card_type = card.brand
          end

          account.subscription.save!
        end
      end
    end
  end
end
