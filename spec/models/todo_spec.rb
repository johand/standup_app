# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:task, type: 'Todo')).to be_valid
  end
end
