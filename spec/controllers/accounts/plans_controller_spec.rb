# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accounts::PlansController, type: :controller do
  login_admin

  describe 'GET #index' do
    it 'returns HTTP success' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:plans).count).to eq(3)
    end
  end
end
