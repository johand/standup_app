# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :account

  def active?
    %w[trialing active past_due].include?(status)
  end
end
