# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Reminders::EmailUserOnTeamJob do
  let(:user) { FactoryBot.create(:user) }
  let(:team) do
    team = FactoryBot.create(
      :team,
      user_ids: [user.id],
      has_reminder: true,
      reminder_time: Time.at(
        Time.now.utc.to_i - (Time.now.utc.to_i % 15.minutes)
      ).utc
    )

    team.update(
      days: [DaysOfTheWeekMembership.new(
        team_id: team.id,
        day: Time.now.utc.strftime('%A').downcase
      )]
    )

    team
  end

  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    Reminders::FindTeamsJob.perform_later
    expect(Reminders::FindTeamsJob).to have_been_enqueued
  end

  it 'enqueues a mailer based job' do
    ActiveJob::Base.queue_adapter = :test
    job = Reminders::EmailUserOnTeamJob.new(team)

    expect { job.perform_now }.to have_enqueued_job.on_queue('mailers')
  end

  it 'reminder email is sent' do
    expect do
      perform_enqueued_jobs do
        EmailReminderMailer.reminder_email(user, team).deliver_later
      end
    end.to change { ActionMailer::Base.deliveries.size }.by(1)
  end
end
