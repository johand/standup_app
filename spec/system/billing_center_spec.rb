# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'BillingCenter', type: :system do
  login_admin
  let(:plan) { Plan.all.first }
  let!(:subscription) do
    FactoryBot.create(:subscription,
                      account_id: @admin.account.id,
                      stripe_customer_id: '1',
                      status: 'trialing',
                      plan_id: plan.stripe_id)
  end

  it 'should dislay basic plan information' do
    stripe_mock_charge_list
    visit billing_index_path

    expect(current_path).to eql(billing_index_path)
    expect(page).to have_content(plan.human_name)
    expect(page).to have_content('Users: 1 / 2')
    expect(page).to have_content('There are no charges on this account at this time')
  end

  it 'should display charges' do
    charge = [{
      id: 'ch_1GWdAWJqqM7ldLAb8ktcjrgE',
      created: Time.now.to_i,
      amount: 100,
      status: 'succeeded',
      statement_descriptor: '',
      source: {
        brand: 'Visa',
        last4: '4242'
      }
    }]

    stripe_mock_charge_list(charge)
    visit billing_index_path

    expect(current_path).to eql(billing_index_path)
    expect(page)
      .to_not have_content('There are no changes on this account at this time')
    expect(page).to have_content(Money.new(100, 'USD'))
  end

  it 'should allow a plan to be added' do
    subscription.destroy
    stripe_mock_customer_success
    stripe_mock_subscription_success
    stripe_mock_charge_list

    visit billing_index_path
    expect(page).to have_content('There is no active plan on the account.')

    click_on 'here'
    visit billing_index_path
    expect(page).to have_content('Plan: Free')
  end

  context 'with an existing stripe token' do
    let!(:subscription) do
      FactoryBot.create(:subscription,
                        account_id: @admin.account.id,
                        stripe_customer_id: '1',
                        status: 'trialing',
                        plan_id: plan.stripe_id,
                        stripe_token: 'card_932uojodwjid')
    end

    it 'should allow a plan to be changed' do
      stripe_mock_charge_list
      stripe_mock_get_customer
      stripe_mock_get_subscription(subscription.stripe_subscription_id)
      stripe_mock_subscription_success

      visit billing_index_path
      click_on 'Change Plan'

      find("a.btn[href='/plans/#{Plan.all.second.stripe_id}']").click

      visit billing_index_path
      expect(page).to have_content('Plan: Starter')
    end
  end

  it 'should allow a plan to be changed', js: true do
    stripe_mock_charge_list
    stripe_mock_get_customer
    stripe_mock_get_subscription(subscription.stripe_subscription_id)
    stripe_mock_subscription_success
    stripe_mock_customer_success
    stripe_get_token

    visit billing_index_path
    click_on 'Change Plan'

    find("a.btn[href='/plans/#{Plan.all.second.stripe_id}']").click
    expect(page).to have_content('Add Card and Change Plan')

    using_wait_time(15) do
      within_frame do
        find_field('cardnumber').send_keys '4242424242424242'
        find_field('exp-date').send_keys '0224'
        find_field('cvc').send_keys '424'
        find_field('postal').send_keys '42424'
      end
    end

    click_button 'Add Card and Change Plan'
    sleep 5 # Give Selenium time to process React/Stripe tokens
    visit billing_index_path

    expect(page).to have_content('Plan: Starter')
  end

  it 'should allow a card to be changed', js: true do
    stripe_mock_charge_list
    stripe_mock_customer_success
    stripe_get_token

    visit billing_index_path
    click_on 'Change Card'

    expect(page).to have_content('Change Card')

    using_wait_time(15) do
      within_frame do
        find_field('cardnumber').send_keys '4242424242424242'
        find_field('exp-date').send_keys '0224'
        find_field('cvc').send_keys '424'
        find_field('postal').send_keys '42424'
      end
    end

    click_button 'Update Card'
    sleep 3 # Give Selenium time to process React/Stripe tokens
    visit billing_index_path

    expect(page).to have_content('8/2021')
  end

  it 'should allow a plan to be canceled' do
    stripe_mock_charge_list
    stripe_mock_subscription_delete

    visit billing_index_path
    expect(page).to have_content('Free')

    click_on 'Cancel Subscription'

    visit billing_index_path
    expect(page).to have_content('There is no active plan on the account.')
  end
end
