# frozen_string_literal: true

module Accounts
  class PlansController < ApplicationController
    skip_before_action :authenticate_user!
    layout 'devise'

    def index
      @plans = Plan.where(active: true, displayable: true)
    end
  end
end
