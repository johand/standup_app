# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BillingController, type: :controller do
  login_admin

  describe 'GET #index' do
    it 'returns HTTP success' do
      stripe_mock_charge_list
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:charges)).to eq([])
    end
  end
end
