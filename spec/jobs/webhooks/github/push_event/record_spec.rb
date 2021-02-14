# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Webhooks::Github::PushEvent::Record do
  let(:account) { FactoryBot.create(:account) }
  let(:team) do
    FactoryBot.create(:team, account_id: account.id)
  end

  let(:json) { JSON.parse(File.read('spec/fixtures/github_events/push_event.json')) }

  it 'matches with enqueued job' do
    Webhooks::Github::PushEvent::Record.perform_later(json, team.id)
    expect(Webhooks::Github::PushEvent::Record).to have_been_enqueued
  end

  it 'enqueues a default based job' do
    expect do
      Webhooks::Github::PushEvent::Record.perform_later(json, team.id)
    end.to have_enqueued_job.on_queue('default')
  end

  it 'creates an event without user in account' do
    expect_any_instance_of(Events::Github).to receive(:save!)
    Webhooks::Github::PushEvent::Record.perform_now(json, team.id)
  end

  it 'creates an event without user in account by github username' do
    FactoryBot.create(
      :user,
      account_id: account.id,
      github_username: 'baxterthehacker'
    )

    expect_any_instance_of(Events::Github).to receive(:save!)
    Webhooks::Github::PushEvent::Record.perform_now(json, team.id)
  end

  it 'creates an event without user in account by github user email' do
    FactoryBot.create(
      :user,
      account_id: account.id,
      email: 'baxterthehacker@users.noreply.github.com'
    )

    expect_any_instance_of(Events::Github).to receive(:save!)
    Webhooks::Github::PushEvent::Record.perform_now(json, team.id)
  end
end
