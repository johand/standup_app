# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Analytics::Mixpanel::IdentifyPersonJob do
  before(:each) do
    ActiveJob::Base.queue_adapter = :test
    @user = FactoryBot.create(:user)
  end

  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    Analytics::Mixpanel::IdentifyPersonJob.perform_later
    expect(Analytics::Mixpanel::IdentifyPersonJob).to have_been_enqueued
  end

  it 'enqueues a default based job' do
    ActiveJob::Base.queue_adapter = :test
    expect { Analytics::Mixpanel::IdentifyPersonJob.perform_later(@user) }
      .to have_enqueued_job.on_queue('default')
  end

  it 'receives a people.set invocation onto the Tracker' do
    expect(TRACKER).to receive_message_chain(%i[people set])
    Analytics::Mixpanel::IdentifyPersonJob.perform_now(@user)
  end
end
