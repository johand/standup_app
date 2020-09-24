# frozen_string_literal: true

class Standup < ApplicationRecord
  belongs_to :user

  validates :user, presence: true

  has_many :task_memberships, dependent: :delete_all
  has_many :tasks, through: :task_memberships

  has_many :dids, -> { where(type: 'Did') }, through: :task_memberships, source: :task
  has_many :todos, -> { where(type: 'Todo') }, through: :task_memberships, source: :task
  has_many :blockers, -> { where(type: 'Blocker') }, through: :task_memberships, source: :task
end
