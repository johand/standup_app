# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'valid Factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  it { is_expected.to have_many(:team_memberships) }
  it { is_expected.to have_many(:teams).through(:team_memberships) }
end
