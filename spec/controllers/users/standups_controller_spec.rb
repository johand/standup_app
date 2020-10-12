# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::StandupsController, type: :controller do
  login_user

  describe 'GET #index' do
    it 'assigns all standups as @standups' do
      standup = FactoryBot.create(:standup, user_id: @user.id)
      get :index, params: { id: @user.id }

      expect(assigns(:user)).to eq(@user)
      expect(assigns(:standups)).to eq([standup])
    end
  end
end
