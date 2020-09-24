# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blocker, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:task, type: 'Blocker')).to be_valid
  end
end
