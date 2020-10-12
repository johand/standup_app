# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :account
  has_many :team_memberships
  has_many :users, through: :team_memberships
  has_many :days, class_name: 'DaysOfTheWeekMembership', dependent: :delete_all
  accepts_nested_attributes_for :days

  validates :account, presence: true
  validates :timezone, presence: true
  validates :name, presence: true
end
