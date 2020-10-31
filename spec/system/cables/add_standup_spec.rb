# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ActionCable Edit Standup', type: :system do
  login_admin

  let(:team) do
    team = FactoryBot.create(
      :team,
      user_ids: [@admin.id],
      has_recap: true,
      recap_time: Time.at(
        Time.now.utc.to_i - (Time.now.utc.to_i % 15.minutes)
      ).utc
    )

    team.update(
      days: [DaysOfTheWeekMembership.new(
        team_id: @team.id,
        day: Time.now.utc.strftime('%A').downcase
      )]
    )

    team.users = [@admin]
    team.save
  end

  let(:standups) do
    [FactoryBot.create(
      :standup,
      standup_date: Date.today.iso8601,
      user_id: @admin.id
    )]
  end

  it 'should see standup edit via ActionCable', js: true do
    visit standups_account_user_path(@admin)

    standup_text = 'Oh yeah!'
    expect(page).not_to have_content(standup_text) # sanity check

    # submit form in new window
    new_window = open_new_window

    within_window new_window do
      visit edit_standup_path(standups.first.standup_date)
      # save_and_open_page
      first('form#standup-form .card-body .links a').click
      find('form#standup-form .card-body .nested-fields input').set standup_text
      click_on 'Save'
    end

    expect do
      switch_to_window(windows.first)
      page.to have_text(standup_text)
    end

    visit root_path
  end
end
