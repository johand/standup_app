# frozen_string_literal: true

module Payments
  module Stripe
    class RemoteSignup
      Result = ImmutableStruct.new(:success?, :error)

      def initialize(params)
        @user = params[:user]
        @account = params[:account]
        @plan = params[:plan]
        @customer = {}
      end

      def process
        create_stripe_customer
        create_subscription_service
      rescue ActiveRecord::RecordInvalid, ::Stripe::StripeError => e
        Result.new(success: false, error: e.message)
      else
        Result.new(success: true)
      end

      private

      attr_reader :user, :account, :plan
      attr_accessor :customer

      def create_stripe_customer
        return customer unless customer.blank?

        uuid = SecureRandom.uuid
        @customer = ::Stripe::Customer.create(
          {
            description: "Customer for #{account.name}",
            email: user.email,
            metadata: { account: account.id }
          },
          idempotency_key: uuid
        )
      end

      def create_subscription_service
        Payments::Stripe::Subscriptions::Create.new(
          customer: customer,
          account: account,
          plan: plan
        ).create
      end
    end
  end
end
