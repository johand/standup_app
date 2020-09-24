# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskMembership, type: :model do
  it { is_expected.to belong_to(:task) }
  it { is_expected.to belong_to(:standup) }
end
