# frozen_string_literal: true

class Standup < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
end
