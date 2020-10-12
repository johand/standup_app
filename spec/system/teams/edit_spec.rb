# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Edit', type: :system do
  login_admin

  let!(:team) { FactoryBot.create(:team, account_id: @admin.account.id) }

  context 'click and edit the team' do
    it 'should click team, edit and go to edit page' do
      visit teams_path

      click_link(id: "team_#{team.id}_header")
      find(".card a[href='#{edit_team_path(team)}']").click

      expect(page).to have_current_path(edit_team_path(team))
      expect(page).to have_content(team.name.to_s)
    end

    context 'click on the edit page' do
      it 'and edit the team successfully' do
        visit teams_path

        click_link(id: "team_#{team.id}_header")
        find(".card a[href='#{edit_team_path(team)}']").click

        within '#team-form' do
          fill_in 'team_name', with: 'Test'
        end

        click_button('Save')

        expect(page).to have_current_path(teams_path)
        expect(page).to have_content('Test')
      end

      it 'and fail to edit the team successfully' do
        visit teams_path

        click_link(id: "team_#{team.id}_header")
        find(".card a[href='#{edit_team_path(team)}']").click

        within '#team-form' do
          fill_in 'team_name', with: ''
        end

        click_button('Save')

        expect(page).to have_current_path(team_path(team))
        expect(page).to have_content("Name can't be blank")
      end
    end
  end
end
