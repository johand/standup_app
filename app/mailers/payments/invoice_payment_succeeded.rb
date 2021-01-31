# frozen_string_literal: true

module Payments
  class InvoicePaymentSucceeded < ApplicationMailer
    default from: "'Standup App' <billing@app.buildasaasappinrails.com>"
    layout 'payment_mailer'

    def email(event)
      event = ::Stripe::Event.retrieve(event)
      subscription = obtain_subscription(event)
      user = subscription.account.users.order(created_at: :asc).first
      @title = 'Payment to Standup App Successful!'
      create_message(event)
      make_bootstrap_mail(to: user.email, subject: @title)
    rescue StandardError => e
      logger.warn "[Stripe] Error: #{e}, No subscription record found for account #{event.data.object.subscription}"
    end

    private

    def obtain_subscription(event)
      subscription = event.data.object.subscription
      Subscription.find_by(stripe_subscription_id: subscription)
    end

    def create_message(event)
      @message = "Thank you for your payment of \
      #{Money.new(event.data.object.amount_due, 'USD').format}\
      that was processed on #{Time.at(event.data.object.status_transitions.paid_at)}."
    end
  end
end
