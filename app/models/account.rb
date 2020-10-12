# frozen_string_literal: true

class Account < ApplicationRecord
  resourcify
  has_many :users
  has_many :teams

  validates :name, presence: true
end
