# frozen_string_literal: true

class Account < ApplicationRecord
  resourcify
  has_many :users
  has_many :teams
  has_one :subscription

  validates :name, presence: true
end
