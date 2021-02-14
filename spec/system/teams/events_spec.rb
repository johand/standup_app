# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Teams', type: :system do
  login_admin

  let(:json) { JSON.parse(File.read('spec/fixtures/github_events/push_event.json')) }
  let(:team) { FactoryBot.create(:team, account_id: @admin.account_id) }

  it "should display a team's events" do
    json['commits'].first['timestamp'] = Time.now.iso8601
    Webhooks::Github::PushEvent::Record.perform_now(json, team.id)

    FactoryBot.create(
      :integration,
      type: 'Integrations::Github',
      account_id: @admin.account_id,
      settings: { token: 'tok123' }
    )

    visit team_path(team)

    expect(page).to have_content('Events')
    expect(page).to have_content(json['commits'].first['message'].to_s)
  end
end
