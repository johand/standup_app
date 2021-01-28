# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeWebhook, type: :model do
  context 'valid factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:stripe_webhook)).to be_valid
    end
  end
end
