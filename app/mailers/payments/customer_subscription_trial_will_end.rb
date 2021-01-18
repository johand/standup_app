# frozen_string_literal: true

module Payments
  class CustomerSubscriptionTrialWillEnd < ApplicationMailer
    default from: "'Standup App' <billing@app.buildasaasappinrails.com>"
    layout 'payment_mailer'

    def mailer(event)
      event = ::Stripe::Event.retrieve(event)
      subscription = obtain_subscription(event)
      user = subscription.account.users.order(created_at: :asc).first
      @title = 'A Payment to Standup App is coming up!'
      create_message(event, subscription)
      make_bootstrap_mail(to: user.email, subject: @title)
    rescue StandardError => e
      logger.warn "[Stripe] Error: #{e} No subscription record found for account \
      #{event.data.object.id}"
    end

    private

    def obtain_subscription(event)
      subscription = event.data.object.id
      Subscription.find_by(stripe_subscription_id: subscription)
    end

    def create_message(event, subscription)
      if subscription.plan_id == 'free'
        create_free_message(event)
      else
        create_paid_message(event)
      end
    end

    def create_paid_message(event)
      @message = "Your trial is coming to an end shortly. On \
      #{Time.at(event.data.object.trial_end)} a payment will be attempted\
      the amount of\
      #{Money.new(event.data.object.items.data.first.plan.amount, 'USD').format}.\n\\
      If you do not have a card on file, wish to change plans or just want to cancel\
      your account, please use the button below to head to the Billing Center"
    end

    def create_free_message(event)
      @message = "Your trial is coming to an end shortly. \
      If you do not have a card on file, wish to change plans or just want to\
      cancel your account, please use the button below to head to the Billing Center"
    end
  end
end
