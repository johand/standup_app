# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityController, type: :controller do
  login_user

  describe 'GET #mine' do
    it 'returns https success' do
      get :mine
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #feed' do
    it 'returns http success' do
      get :feed
      expect(response).to have_http_status(:success)
    end
  end
end
