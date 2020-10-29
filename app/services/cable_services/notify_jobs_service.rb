# frozen_string_literal: true

module CableServices
  class NotifyJobsService
    attr_reader :standup, :user

    def initialize(params)
      @standup = params[:standup]
      @user = params[:user]
    end

    def notify(action)
      if action == :update
        Cables::Broadcasts::StandupItemJob.perform_later(standup)
      else
        Cables::Broadcasts::UserStandupItemJob.perform_later(standup)
        Cables::Broadcasts::TeamStandupItemJob.perform_later(standup)
        Cables::Broadcasts::StandupNotificationJob.perform_later(user)
      end
    end
  end
end
