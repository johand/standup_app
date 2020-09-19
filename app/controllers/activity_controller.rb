# frozen_string_literal: true

class ActivityController < ApplicationController
  authorize_resource class: 'ActivityController'

  def mine; end

  def feed; end
end
