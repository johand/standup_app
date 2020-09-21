# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  attr_accessor :role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :account, optional: true
  has_many :team_memberships
  has_many :teams, through: :team_memberships
end
