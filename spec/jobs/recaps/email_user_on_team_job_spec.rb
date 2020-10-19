# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Recaps::EmailUserOnTeamJob do
  let(:user) { FactoryBot.create(:user) }
  let(:team) do
    team = FactoryBot.create(
      :team,
      user_ids: [user.id],
      has_recap: true,
      recap_time: Time.at(
        Time.now.utc.to_i - (Time.now.utc.to_i % 15.minutes)
      ).utc
    )

    team.update(
      days: [DaysOfTheWeekMembership.new(
        team_id: team.id,
        day: Time.now.utc.strftime('%A').downcase
      )],

      users: [user]
    )

    team
  end

  let!(:standups) do
    [
      FactoryBot.create(
        :standup,
        standup_date: Date.today.iso8601,
        user_id: user.id
      )
    ]
  end

  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    Recaps::EmailUserOnTeamJob.perform_later
    expect(Recaps::EmailUserOnTeamJob).to have_been_enqueued
  end

  it 'enqueues a mailer based job' do
    ActiveJob::Base.queue_adapter = :test
    job = Recaps::EmailUserOnTeamJob.new(team, Date.today.iso8601)
    expect { job.perform_now }.to have_enqueued_job.on_queue('mailers')
  end

  it 'recap email is sent' do
    expect do
      perform_enqueued_jobs do
        EmailRecapMailer.recap_email(user, team, standups).deliver_later
      end
    end.to change { ActionMailer::Base.deliveries.size }.by(1)
  end
end
