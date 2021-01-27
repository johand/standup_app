# frozen_string_literal: true

module Payments
  class InvoiceUpcoming < ApplicationMailer
    default from: "'Standup App' <billing@app.buildasaasappinrails.com>"
    layout 'payment_mailer'

    def email(event)
      event = ::Stripe::Event.retrieve(event)
      subscription = obtain_subscription(event)
      user = subscription.account.users.order(created_at: :asc).first
      @title = 'Payment to Standup App is coming up!'
      create_message(event)
      make_bootstrap_mail(to: user.email, subject: @title)
    rescue StandardError => e
      logger.warn "[Stripe] Error: #{e}, No subscription record found for \
      account #{event.data.object.subscription}"
    end

    private

    def obtain_subscription(event)
      subscription = event.data.object.subscription
      Subscription.find_by(stripe_subscription_id: subscription)
    end

    def create_message(event)
      @message = "Your account has a payment coming up. The payment will be for\
      the amount of #{Money.new(event.data.object.amount_due, 'USD').format}\
      and will processed on #{Time.at(event.data.object.next_payment_attempt)}"
    end
  end
end
