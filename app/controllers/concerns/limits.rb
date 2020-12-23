# frozen_string_literal: true

module Limits
  def check_limits(resource_type)
    current_account.send(resource_type.to_s).count < limit(resource_type)
  end

  def check_resource_against_limits(resource_type, &failure_block)
    yield failure_block unless check_limits(resource_type)
  end

  def limit(resource_type)
    Plan.find(current_subscription.plan_id).send(resource_type)
  end
end
