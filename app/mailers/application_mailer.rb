# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['email']
  layout 'bootstrap-mailer'
end
