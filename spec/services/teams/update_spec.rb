# frozen_string_literal: true

require 'rails_helper'

describe Teams::Update do
  subject(:teams_update) { Teams::Update }

  describe 'create an account' do
    context 'from form input' do
      let(:team) { FactoryBot.build(:team) }
      let(:user) { FactoryBot.create(:user) }
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

      it 'updates a team' do
        expect do
          teams_update.new(team, valid_attributes).update
        end.to change(Team, :count).by(1)
      end

      it 'does not update a team' do
        expect do
          account.id = nil
          teams_update.new(team, valid_attributes).update
        end.to change(Team, :count).by(0)
      end
    end
  end
end
