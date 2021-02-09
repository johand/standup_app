# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:integration)).to be_valid
  end

  it { is_expected.to belong_to(:account) }
end
