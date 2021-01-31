# frozen_string_literal: true

module StripeSync
  module Plans
    def self.sync!
      remote_plans = Stripe::Plan.list({ limit: 20 })
      ::Plan.all.each do |yml_plan|
        if plan ||= remote_plans.find { |p| p.id == yml_plan.stripe_id }
          Stripe::Plan.delete(yml_plan.stripe_id)
        end

        Rails.logger.info "Creating Plan: #{yml_plan.human_name}\n"
        plan_response = create_plan(yml_plan)
        Rails.logger.info "Created plan: #{plan_response.id} within product: #{plan_response.product}"
      end
    end

    def self.create_plan(yml_plan)
      Stripe::Plan.create(
        id: yml_plan.stripe_id,
        amount: yml_plan.amount,
        interval: yml_plan.interval,
        product: {
          id: yml_plan.stripe_id,
          name: yml_plan.human_name
        },
        currency: 'usd',
        trial_period_days: 14
      )
    end
  end
end
