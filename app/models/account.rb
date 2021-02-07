# frozen_string_literal: true

class Account < ApplicationRecord
  resourcify
  has_many :users
  has_many :teams
  has_one :subscription
  has_one :github, class_name: 'Integrations::Github'
  validates :name, presence: true
end
