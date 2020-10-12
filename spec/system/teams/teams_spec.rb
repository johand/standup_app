# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Teams', type: :system do
  login_admin

  let!(:team) { FactoryBot.create(:team, account_id: @admin.account.id) }

  it 'should be able to visit the team index and see at least one team' do
    visit teams_path

    expect(current_path).to eql(teams_path)
    expect(page).to have_content('Teams')
    expect(page).to have_content(team.name.to_s)
  end

  it 'should click team and see show page' do
    visit teams_path

    click_link(id: "team_#{team.id}_header")

    expect(current_path).to eql(team_path(team))
    expect(page).to have_content(team.name.to_s)
  end
end
