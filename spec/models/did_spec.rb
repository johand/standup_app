# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Did, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:task, type: 'Did')).to be_valid
  end
end
