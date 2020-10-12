# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  context 'valid Factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:account)).to be_valid
    end
  end

  it { is_expected.to validate_presence_of(:name) }
end
