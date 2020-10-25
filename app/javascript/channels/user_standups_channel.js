import consumer from './consumer';

let users = [];

const createUserStandupConsumers = userId => {
  if (!users.includes(userId)) {
    consumer.subscriptions.create(
      { channel: 'UserStandupsChannel', user_id: userId },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          users = [...users, userId];
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          // Called when there's incoming data on the websocket for this channel
          console.log(`[ActionCable] [Standup]`, data);
          $('#user-standups-container').first().replaceWith(data.html);
        },
      },
    );
  }
};

$(document).on('turbolinks:load', () => {
  const userStandupsElem = $('#user-standups-container');

  if (userStandupsElem.length > 0) {
    createUserStandupConsumers(window.location.pathname.split('/')[3]);
  }
});
