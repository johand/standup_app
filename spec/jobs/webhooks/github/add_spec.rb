# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Webhooks::Github::Add do
  let(:account) { FactoryBot.create(:account) }
  let(:team) do
    FactoryBot.create(
      :team,
      account_id: account.id,
      integration_settings: {
        github_repos: ['test|one']
      }
    )
  end

  before(:each) do
    FactoryBot.create(
      :integration,
      type: 'Integrations::Github',
      account_id: account.id,
      settings: { token: '<< your token >>' }
    )
  end

  it 'matches with an enqueued job' do
    Webhooks::Github::Add.perform_later(['math_probability|foo-bar'], team)
    expect(Webhooks::Github::Add).to have_been_enqueued
  end

  it 'enqueues a default based job' do
    expect do
      Webhooks::Github::Add.perform_later(['math_probability|foo-bar'], team)
    end.to have_enqueued_job.on_queue('default')
  end

  it 'adds a webhook' do
    github_mock_webhook_add('foo-bar', 'math_probability')
    expect_any_instance_of(Github::Client::Repos::Hooks)
      .to receive(:create).and_call_original
    Webhooks::Github::Add.perform_now(['math_probability|foo-bar'], team)
  end
end
