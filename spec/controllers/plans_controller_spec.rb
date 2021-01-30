# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlansController, type: :controller do
  login_admin

  before do
    stripe_mock_customer_success
    stripe_mock_subscription_success
    stripe_mock_get_customer(@admin.account.subscription.stripe_customer_id)
    stripe_mock_get_subscription(@admin.account.subscription.stripe_subscription_id)
  end

  describe 'GET #index' do
    it 'returns HTTP success' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:plans).count).to eq(3)
    end
  end

  describe 'GET #show' do
    it 'returns HTTP success free' do
      get :show, params: { id: 'free' }
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Plan was updated successfully.'
    end

    it 'returns HTTP success starter' do
      get :show, params: { id: 'starter' }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('show')
    end

    it 'returns HTTP success starter token' do
      @admin.account.subscription.update(stripe_token: 'tk_123')
      get :show, params: { id: 'starter' }
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Plan was updated successfully.'
    end

    it 'returns HTTP success free no subscription' do
      @admin.account.subscription.update(plan_id: nil)
      get :show, params: { id: 'free' }
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Plan was updated successfully.'
    end

    it 'returns HTTP success free no subscription error' do
      @admin.account.subscription.update(plan_id: nil)
      stripe_mock_customer_success(::Stripe::StripeError)
      get :show, params: { id: 'free' }
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Plan was unable to be updated!'
    end
  end
end
