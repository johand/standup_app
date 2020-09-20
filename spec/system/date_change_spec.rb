# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Date Change', type: :system do
  login_admin

  let(:team) { FactoryBot.create(:team, account_id: @admin.account.id) }

  it 'should be able to visit standups and move date forward' do
    visit team_standups_path(team)

    click_on(id: 'date_forward')

    expect(page).to have_current_path("/t/#{team.id}/s/#{(Date.today + 1.day).iso8601}")
    expect(page).to have_content((Date.today + 1.day).strftime("%a. %n #{(Date.today + 1.day).day.ordinalize}"))
  end

  it 'should be able to visit standups and move date backwards' do
    visit team_standups_path(team)

    click_on(id: 'date_backwards')

    expect(page).to have_current_path("/t/#{team.id}/s/#{(Date.today - 1.day).iso8601}")
    expect(page).to have_content((Date.today - 1.day).strftime("%a. %n #{(Date.today + 1.day).day.ordinalize}"))
  end

  it 'should be able to visit standups and move date from picker', js: true do
    visit team_standups_path(team)

    date_milliseconds = (Time.now.utc.beginning_of_day + 1.day).to_i * 1000

    find('#datePicker').click
    find("td.day[data-date='#{date_milliseconds}']").click

    expect(page).to have_current_path(team_standups_by_date_path(team, (Date.today + 1.day).iso8601))
    expect(page).to have_content(
      Time.at(date_milliseconds / 1000)
        .utc
        .strftime(
          "%a, %b #{Time.at(date_milliseconds / 1000).utc.day.ordinalize}"
        )
    )
  end
end
