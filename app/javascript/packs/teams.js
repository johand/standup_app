$(document).on('turbolinks:load', () => {
  $(document).on('click', '#team_has_reminder', e => {
    $('#reminder-time-box').toggle();
  });

  $(document).on('click', '#team_has_recap', e => {
    $('#recap-time-box').toggle();
  });

  $(document).on(
    'change',
    '#team_integration_settings_github_collect_events',
    e => {
      if ($(e.target).val() === 'true') {
        $('#integration_settings-github-repo-box').show();
      } else {
        $('#integration_settings-github-repo-box').hide();
      }
    },
  );
});
