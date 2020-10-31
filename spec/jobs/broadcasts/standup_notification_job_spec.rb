# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Cables::Broadcasts::StandupNotificationJob do
  let(:user) { FactoryBot.create(:user) }
  let!(:team) do
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
      )]
    )

    team
  end

  let(:standup) do
    FactoryBot.create(
      :standup,
      standup_date: Date.today.iso8601,
      user_id: user.id
    )
  end

  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    Cables::Broadcasts::StandupNotificationJob.perform_later
    expect(Cables::Broadcasts::StandupNotificationJob).to have_been_enqueued
  end

  it 'enqueues a default based job' do
    ActiveJob::Base.queue_adapter = :test
    expect { Cables::Broadcasts::StandupNotificationJob.perform_later(standup.user) }
      .to have_enqueued_job.on_queue('default')
  end

  it 'renders a partial' do
    expect(ApplicationController).to receive(:render)
    Cables::Broadcasts::StandupNotificationJob.perform_now(standup.user)
  end
end
