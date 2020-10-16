# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe WelcomeEmailMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user, email: 'awesome@dabomb.com') }

  it 'job is created' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      WelcomeEmailMailer.welcome_email(user).deliver_later
    end.to have_enqueued_job.on_queue('mailers')
  end

  it 'welcome_email is sent' do
    expect do
      perform_enqueued_jobs do
        WelcomeEmailMailer.welcome_email(user).deliver_later
      end
    end.to change { ActionMailer::Base.deliveries.size }.by(1)
  end

  it 'welcome_email is sent to the right user' do
    perform_enqueued_jobs do
      WelcomeEmailMailer.welcome_email(user).deliver_later
    end

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to[0]).to eq(user.email)
  end
end
