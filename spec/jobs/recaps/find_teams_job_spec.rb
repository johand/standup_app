# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Recaps::FindTeamsJob do
  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    Recaps::FindTeamsJob.perform_later
    expect(Recaps::FindTeamsJob).to have_been_enqueued
  end

  context 'finding team with recaps' do
    let!(:team) do
      team = FactoryBot.create(
        :team,
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

    it 'finds a team with recaps when there is a subscription' do
      job = Recaps::FindTeamsJob.new
      job.perform_now
      expect(job.instance_variable_get(:@teams)).to eq([team])
    end

    it 'does not find a team with recaps due to no active subscription' do
      team.account.subscription.update!(plan_id: nil, status: 'canceled')
      job = Recaps::FindTeamsJob.new
      expect(Recaps::EmailUserOnTeamJob).to_not receive(:perform_later)
      job.perform_now
    end
  end
end
