# frozen_string_literal: true

module Teams
  module Shared
    Result = ImmutableStruct.new(:success?, :team, :error)

    def days_of_the_week
      team.days = team_params[:days]&.map do |day|
        DaysOfTheWeekMembership.new(
          team_id: team.id,
          day: day
        )
      end || []
    end

    def convert_zone_times_to_utc
      convert_reminder
      convert_recap
    end

    def convert_reminder
      return nil unless team.reminder_time && team.has_reminder

      team.reminder_time = ActiveSupport::TimeZone[team.timezone]
                           .parse(team.reminder_time.to_s[11..18]).utc
    end

    def convert_recap
      return nil unless team.recap_time && team.has_recap

      team.recap_time = ActiveSupport::TimeZone[team.timezone]
                        .parse(team.recap_time.to_s[11..18]).utc
    end
  end
end
