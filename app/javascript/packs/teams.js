$(document).on('turbolinks:load', () => {
  $(document).on('click', '#team_has_reminder', e => {
    $('#reminder-time-box').toogle();
  });

  $(document).on('click', '#team_has_recap', e => {
    $('#recap-time-box').toogle();
  });
});
