# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IntegrationsController, type: :controller do
  login_admin

  describe 'GET #index' do
    it 'returns HTTP success' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:grepos)).to eq(nil)
    end

    it 'returns HTTP success when Github Integration exists' do
      FactoryBot.create(
        :integration,
        type: 'Integrations::Github',
        account_id: @admin.account.id,
        settings: { token: 'tok123' }
      )

      github_mock_repo_list
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:github)).to be_truthy
      expect(assigns(:grepos)).to be_truthy
    end
  end

  describe 'Delete #destroy' do
    before do
      FactoryBot.create(
        :integration,
        type: 'Integrations::Github',
        account_id: @admin.account.id
      )
    end

    it 'returns HTTP success' do
      delete :destroy, params: { provider: 'github' }
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Removed Github integration. Please be sure to rem\
ove the application through your settings area in Github'
    end

    it 'does not delete integration' do
      delete :destroy, params: { provider: '!github' }
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Unable to removed !github integration'
    end
  end
end
