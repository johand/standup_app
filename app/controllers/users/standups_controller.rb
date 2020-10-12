# frozen_string_literal: true

module Users
  class StandupsController < ApplicationController
    def index
      @standups = user.standups
                      .includes(:dids, :todos, :blockers)
                      .references(:tasks)
                      .order('standup_date DESC')
    end

    private

    def user
      @user ||= User.find(params[:id])
    end
  end
end
