# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper
ActiveJob::Base.queue_adapter = :test

RSpec.describe "SignUpProcesses", type: :system do
  before do
    driven_by(:rack_test)
    allow(Slack::Notifier).to receive_message_chain(:new, :ping) { nil }
  end

  it 'should require the user to sign up and successfully sign up' do
    visit root_path

    click_link 'Sign up'

    find("a.btn[href='#{new_user_registration_path(plan: Plan.all.first.stripe_id)}']").click

    within '#new_user' do
      fill_in 'user_name', with: 'Test'
      fill_in 'user_email', with: 'test@test.com'
      fill_in 'user_password', with: 'password123'
      fill_in 'user_password_confirmation', with: 'password123'
    end

    click_button 'Sign up'

    expect(current_path).to eql(new_accounts_path)

    within '#new_account' do
      fill_in 'account_name', with: 'Test CO'
    end

    expect do
      click_button 'Save'
      expect(ActionMailer::Base.deliveries.last.to).to eq['test@test.com']
      expect(current_path).to eql(root_path)
    end
  end

  it 'should fail on invalid user information' do
    visit root_path

    click_on 'Sign up'

    find("a.btn[href='#{new_user_registration_path(plan: Plan.all.first.stripe_id)}']").click

    within '#new_user' do
      fill_in 'user_name', with: 'Test'
      fill_in 'user_email', with: 'test'
      fill_in 'user_password', with: 'p'
    end

    click_button 'Sign up'

    expect(current_path).to eql('/users')
    expect(page).to have_content('error')
  end

  it 'should fail on invalid account information' do
    visit root_path

    click_on 'Sign up'

    find("a.btn[href='#{new_user_registration_path(plan: Plan.all.first.stripe_id)}']").click

    within '#new_user' do
      fill_in 'user_name', with: 'Test'
      fill_in 'user_email', with: 'test2@test.com'
      fill_in 'user_password', with: 'password123'
      fill_in 'user_password_confirmation', with: 'password123'
    end

    click_button 'Sign up'

    within '#new_account' do
      fill_in 'account_name', with: ''
    end

    click_button 'Save'
    expect(current_path).to eql('/accounts')
    expect(page).to have_content('error')
  end
end
