# frozen_string_literal: true

class BillingController < ApplicationController
  def index
    render(:index) && return if current_subscription.nil?

    begin
      @charges = Stripe::Charge.list(
        customer: current_subscription.stripe_customer_id
      ).data
    end
  end

  def change_card; end
end
