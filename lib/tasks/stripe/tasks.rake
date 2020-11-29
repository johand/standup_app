# frozen_string_literal: true
require 'stripe_sync/plans'

namespace :stripe do
  desc 'sync plans from local YAML file to Stripe account'
  task 'plans:sync' => 'environment' do
    StripeSync::Plans.sync!
  end
end
