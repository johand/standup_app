# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:task)).to be_valid
  end

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to have_many(:task_memberships) }
  it { is_expected.to have_many(:standups).through(:task_memberships) }
end
