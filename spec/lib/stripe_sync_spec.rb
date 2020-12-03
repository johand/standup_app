# frozen_string_literal: true

require 'rails_helper'
require 'stripe_sync/plans'

describe StripeSync::Plans do
  describe 'create plans' do
    let(:plan_ids) { %w[free starter unlimited] }

    before do
      plan_ids.each { |plan_id| stripe_mock_plan_create_success(plan_id) }
    end

    it 'creates plans' do
      stripe_mock_plan_list
      expect(Stripe::Plan).to receive(:create).exactly(3).times.and_call_original
      StripeSync::Plans.sync!
    end

    it 'updated through delete plans' do
      stripe_mock_plan_list([{ "id": 'free' }])
      stripe_mock_plan_delete('free')
      StripeSync::Plans.sync!
    end
  end
end
