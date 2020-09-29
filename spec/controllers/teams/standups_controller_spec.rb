# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Teams::StandupsController, type: :controller do
  login_admin

  describe 'GET #index' do
    it 'assigns all standups as @standups' do
      team = FactoryBot.create(:team, account_id: @admin.account.id)
      FactoryBot.create(:team_membership, user_id: @admin.id, team_id: team.id)
      FactoryBot.create(:standup, user_id: @admin.id)
      get :index, params: { id: team.id }

      expect(assigns(:team)).to eq(team)
      expect(assigns(:standups)).to eq([])
    end
  end
end
