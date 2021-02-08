# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :team
  belongs_to :user
end
