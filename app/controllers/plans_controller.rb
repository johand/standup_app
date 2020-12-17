# frozen_string_literal: true

class PlansController < ApplicationController
  def index
    @plans = Plan.where(active: true, displayable: true)
  end

  def show
    return if handle_free_plan_selected
    return if handle_token_presence

    @plan = Plan.find(params[:id])
    @subscription = Subscription.new
  end

  private

  def handle_free_plan_selected
    return false unless params[:id] == 'free'

    response =
      if current_subscription&.plan_id
        stripe_subscription_update_service(token: false).update
      else
        stripe_subscriptions_remote_signup_service.process
      end

    handle_response(
      response: response,
      success_message: 'Plan was updated successfully.',
      failure_message: 'Plan was unable to be updated!'
    )
  end

  def handle_token_presence
    return false unless current_subscription.stripe_token

    response = stripe_subscription_update_service(token: false).update
    handle_response(
      response: response,
      success_message: 'Plan was updated successfully.',
      failure_message: 'Plan was unable to be updated!'
    )
  end

  def handle_response(response:,
                      success_message:,
                      success_path: billing_index_path,
                      failure_message:,
                      failure_path: billing_index_path)
    if response.success?
      redirect_back(fallback_location: success_path, notice: success_message) && true
    else
      logger.info "[STRIPE] Problem: #{response.error}"
      redirect_back(fallback_location: failure_path, notice: failure_message) && true
    end
  end

  def stripe_subscriptions_remote_signup_service
    Payments::Stripe::RemoteSignup.new(
      customer: current_subscription&.stripe_customer_id,
      user: current_user,
      account: current_account,
      plan: params[:id]
    )
  end

  def stripe_subscription_update_service(token:)
    options = {
      account: current_account,
      plan: params[:id]
    }

    options[:source] = token if token
    Payments::Stripe::Subscriptions::Update.new(
      options
    )
  end
end
