# frozen_string_literal: true

module CableServices
  class NotifyJobsService
    attr_reader :standup, :user

    def initialize(params)
      @standup = params[:standup]
      @user = params[:user]
    end

    def notify(action)
      Cables::Broadcasts::StandupItemJob.perform_later(standup) if action == :update
    end
  end
end
