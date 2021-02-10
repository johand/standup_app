# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe 'GET #github' do
    login_admin

    before(:each) do
      OmniAuth.config.test_mode = true
    end

    it 'passes auth and return HTTP redirect' do
      OmniAuth.config.add_mock(:github, { credentials: { token: '12345' } })
      request.env['devise.mapping'] = Devise.mappings[:user] # If using Devise
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]

      get :github
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Github integration has been added'
    end

    it 'fails auth and returns HTTP redirect' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      request.env['devise.mapping'] = Devise.mappings[:user] # If using Devise
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]

      get :github
      expect(response).to have_http_status(:redirect)
      expect(flash[:alert]).to eq 'Github was unable to add integration. Contact support if this issue persists.'
    end
  end
end
