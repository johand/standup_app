# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlackNotificationJob, type: :job do
  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    SlackNotificationJob.perform_later
    expect(SlackNotificationJob).to have_been_enqueued
  end
end
