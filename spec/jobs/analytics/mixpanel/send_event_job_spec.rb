# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analytics::Mixpanel::SendEventJob do
  let(:user) { FactoryBot.create(:user) }

  it 'matches with enqueued job' do
    Analytics::Mixpanel::SendEventJob.perform_later
    expect(Analytics::Mixpanel::SendEventJob).to have_been_enqueued
  end

  it 'enqueues a default based job' do
    expect { Analytics::Mixpanel::SendEventJob.perform_later(user, '', {}) }
      .to have_enqueued_job.on_queue('default')
  end

  it 'receives a track invocation onto the Tracker' do
    expect(TRACKER).to receive(:track)
    Analytics::Mixpanel::SendEventJob.perform_now(user, '', {})
  end
end
