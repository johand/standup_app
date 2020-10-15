# frozen_string_literal: true

class EmailReminderMailer < ApplicationMailer
  def reminder_email(user, team)
    @user = user
    @team = team
    make_bootstrap_mail(to: @user.email, subject: "#{team.name} Standup Reminder!")
  end
end
