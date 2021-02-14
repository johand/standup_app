# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::Github, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:event, type: 'Events::Github')).to be_valid
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:team) }
end
