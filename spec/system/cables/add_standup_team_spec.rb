# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ActionCable Add Standup Team Show', type: :system do
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
        team_id: team.id,
        day: Time.now.utc.strftime('%A').downcase
      )]
    )

    team.users = [@admin]
    team.save
    team
  end

  context 'should see standup added' do
    it 'to teams_show via ActionCable', js: true do
      visit team_path(team)

      standup_text = 'Oh yeah!'

      expect(page).not_to have_content(standup_text) # sanity check

      # submit form in new window
      new_window = open_new_window

      within_window new_window do
        visit new_standup_path(Date.today.iso8601)
        # save_and_open_page
        first('form#standup-form .card-body .links a').click
        find('form#standup-form .card-body .nested-fields input.form-control.input-lg').set standup_text
        click_on 'Save'
      end

      # check for new valie in the previous window without page refreshing
      expect do
        switch_to_window(windows.first)
        page.to have_text(standup_text)
      end

      visit root_path
    end

    it 'to teams_standups via ActionCable', js: true do
      visit team_standups_path(team)

      standup_text = 'Oh yeah!'

      expect(page).not_to have_content(standup_text) # sanity check

      # submit form in new window
      new_window = open_new_window

      within_window new_window do
        visit new_standup_path(Date.today.iso8601)
        # save_and_open_page
        first('form#standup-form .card-body .links a').click
        find('form#standup-form .card-body .nested-fields input.form-control.input-lg').set standup_text
        click_on 'Save'
      end

      # check for new valie in the previous window without page refreshing
      expect do
        switch_to_window(windows.first)
        page.to have_text(standup_text)
      end

      visit root_path
      page.reset!
    end
  end
end
