import consumer from './consumer';

$(document).on('turbolinks:load', () => {
  $(document).on('click', '.notifications-menu .dropdown-toggle', () => {
    $('.notifications-menu .dropdown-toggle .label-warning').hide();
  });
});

const notificationsSubscription =
  notificationsSubscription ||
  consumer.subscriptions.create('NotificationsChannel', {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log(`[ActionCable] [Notifications]`, data);
      $('#notification-container').first().html(data.html);
      $('#notification-container')
        .first()
        .parent()
        .parent()
        .find('.badge-warning')
        .show();
    },
  });
