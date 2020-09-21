# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :account
  has_many :team_memberships
  has_many :users, through: :team_memberships

  validates :account, presence: true
  validates :timezone, precense: true
  validates :name, presence: true
end
