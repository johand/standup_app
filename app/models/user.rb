# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  attr_accessor :role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:github]

  belongs_to :account, optional: true
  has_many :team_memberships
  has_many :teams, through: :team_memberships
  has_many :standups

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  def after_database_authentication
    Analytics::Mixpanel::IdentifyPersonJob.perform_later(self)
  end
end
