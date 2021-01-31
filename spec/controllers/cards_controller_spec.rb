# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  login_admin

  describe 'POST #create' do
    it 'return HTTP success on failure' do
      stripe_mock_customer_success(::Stripe::StripeError)
      stripe_get_token
      post :create, params: { stripeToken: 'tk_123' }

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Card was not successfully updated.'
    end

    it 'return HTTP success on success' do
      stripe_mock_customer_success
      stripe_get_token
      post :create, params: { stripeToken: 'tk_123' }

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Card was successfully updated.'
    end
  end
end
