# frozen_string_literal: true

module Payments
  class InvoicePaymentFailed < ApplicationMailer
    default from: "'Standup App' <billing@app.buildasaasappinrails.com>"
    layout 'payment_mailer'

    def mailer(event)
      event = ::Stripe::Event.retrieve(event)
      subscription = obtain_subscription(event)
      user = subscription.account.users.order(created_at: :asc).first
      @title = 'Payment to Standup App Failed!'
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
      @message = "Unfortunately your most recent invoice payment for\
      #{Money.new(event.data.object.amount_due, 'USD').format}\
      was declined. This could be due to a change in your card number or your\
      card expiring, cancelation of your credit card, or the bank not\
      recognizing the payment and taking action to prevent it."
    end
  end
end
