# frozen_string_literal: true

class EmailReminderMailer < ApplicationMailer
  def reminder_email(user, team)
    @user = user
    @team = team
    @events =
      Event.where(team_id: @team.id,
                  event_time: 24.hours.ago..Time.now)
           .includes(%i[user team])
           .order('event_time DESC')
    make_bootstrap_mail(to: @user.email, subject: "#{team.name} Standup Reminder!")
  end
end
