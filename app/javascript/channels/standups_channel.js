import consumer from './consumer';

let standups = [];

const createStandupConsumers = standupId => {
  if (!standups.includes(standupId)) {
    consumer.subscriptions.create(
      { channel: 'StandupsChannel', standup_id: standupId },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          standups = [...standups, standupId];
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          // Called when there's incoming data on the websocket for this channel
          console.log(`[ActionCable] [Standup] [${data.id}]`, data);
          const box = $(`.standup-box[data-standup='${data.id}']`);

          if (box) {
            box.find('.card-body').first().replaceWith(data.html);
          }
        },
      },
    );
  }
};

$(document).on('turbolinks:load', () => {
  const standups = $('.standup-box')
    .map(function () {
      return $(this).attr('data-standup');
    })
    .get();

  if (standups.length > 0) {
    standups.map(standup => createStandupConsumers(standup));
  }
});
