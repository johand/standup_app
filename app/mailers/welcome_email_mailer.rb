# frozen_string_literal: true

class WelcomeEmailMailer < ApplicationMailer
  default from: "'Standup App' <welcome@standup-app.com>"

  def welcome_email(user)
    @user = user
    make_bootstrap_mail(to: @user.email, subject: "Welcome to Standup App, #{user.name}!!")
  end
end
