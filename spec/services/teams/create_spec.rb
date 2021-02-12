# frozen_string_literal: true

require 'rails_helper'
include CanCan::ControllerAdditions

describe Teams::Create do
  subject(:teams_create) { Teams::Create }

  describe 'create an account' do
    context 'from form input' do
      let(:team) { FactoryBot.build(:team) }
      let(:user) { FactoryBot.create(:user) }
      let(:current_user) { user }
      let(:account) { FactoryBot.create(:account) }
      let(:valid_attributes) do
        {
          name: Faker::Team.name,
          description: Faker::Company.catch_phrase,
          account_id: account.id,
          timezone: 'Arizona',
          has_reminder: true,
          reminder_time: Time.now,
          has_recap: true,
          recap_time: Time.now
        }
      end

      before(:each) do
        user.add_role :admin
      end

      it 'creates a team' do
        expect do
          teams_create.new(
            team,
            account,
            valid_attributes, -> { authorize!(:create, @team) }
          ).create
        end.to change(Team, :count).by(1)
      end

      it 'does not create a team' do
        expect do
          account.id = nil
          teams_create.new(
            team,
            account,
            valid_attributes, -> { authorize!(:create, @team) }
          ).create
        end.to change(Team, :count).by(0)
      end
    end
  end
end
