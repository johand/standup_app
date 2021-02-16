# frozen_string_literal: true

TRACKER = Mixpanel::Tracker.new(Rails.application.credentials.mixpanel[:token])
