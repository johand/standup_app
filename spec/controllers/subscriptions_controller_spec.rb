# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  login_admin

  before do
    stripe_mock_customer_success
    stripe_mock_subscription_success
    stripe_get_token
    stripe_mock_get_customer(@admin.account.subscription.stripe_customer_id)
    stripe_mock_get_subscription(@admin.account.subscription.stripe_subscription_id)
  end

  describe 'POST #create' do
    it 'returns HTTP failure path' do
      stripe_mock_subscription_success(::Stripe::StripeError)
      post :create, params: {
        plan: 'starter',
        stripeToken: 'tk_123'
      }

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Plan was not able to be added!'
    end

    it 'returns HTTP success path' do
      post :create, params: {
        plan: 'starter',
        stripeToken: 'tk_123'
      }

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Plan was successfully added!'
    end
  end

  describe 'DELETE #destroy' do
    it 'returns HTTP success failure path' do
      stripe_mock_subscription_delete(error: ::Stripe::StripeError)
      delete :destroy, params: {
        id: @admin.account.subscription.stripe_subscription_id
      }

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Plan unable to be canceled.'
    end

    it 'returns HTTP success path' do
      stripe_mock_subscription_delete
      delete :destroy, params: { id: @admin.account.subscription.stripe_subscription_id }

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Plan has been canceled.'
    end
  end
end
