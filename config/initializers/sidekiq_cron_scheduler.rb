# frozen_string_literal: true

jobs_hash = {
  'reminder' => {
    'class' => 'Reminders::FindTeamsJob',
    'cron' => '0,15,30,45 * * * *',
    'active_job' => true
  }
}

if Sidekiq.server?
  Rails.application.config.after_initialize do
    Sidekiq::Cron::Job.load_from_hash! jobs_hash
  end
end
