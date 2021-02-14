# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Webhooks::Github::Remove do
  let(:account) { FactoryBot.create(:account) }
  let(:team) do
    FactoryBot.create(
      :team,
      account_id: account.id,
      integration_settings: {
        github_repos: ['test|one'],
        github_webhooks: [{
          'id': '123',
          'repo_name': 'math_probability',
          'repo_owner': 'foo-bar'
        }]
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

  it 'matches with enqueued job' do
    Webhooks::Github::Remove.perform_later(['math_probability|foo-bar'], team)
    expect(Webhooks::Github::Remove).to have_been_enqueued
  end

  it 'enqueues a default based job' do
    expect do
      Webhooks::Github::Remove.perform_later(['math_probability|foo-bar'], team)
    end.to have_enqueued_job.on_queue('default')
  end

  it 'updates a subscription' do
    github_mock_webhook_remove('foo-bar', 'math_probability', '123')
    expect_any_instance_of(Github::Client::Repos::Hooks)
      .to receive(:delete).and_call_original
    Webhooks::Github::Remove.perform_now(['math_probability|foo-bar'], team)
  end
end
