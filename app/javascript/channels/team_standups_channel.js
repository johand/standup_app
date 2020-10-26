import consumer from './consumer';

let teams = [];

const createTeamStandupConsumers = teamId => {
  if (!teams.includes(teamId)) {
    consumer.subscriptions.create(
      { channel: 'TeamStandupsChannel', team_id: teamId, date: getDate() },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          teams = [...teams, teamId];
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          // Called when there's incoming data on the websocket for this channel
          console.log(`[ActionCable] [Standup]`, data);

          $('#team-standups-container').first().replaceWith(data.html);
        },
      },
    );
  }
};

const getDate = () => {
  if (typeof window.location.pathname.split('/')[4] != 'undefined') {
    return window.location.pathname.split('/')[4];
  } else {
    return new Date().toISOString().substring(0, 10);
  }
};

$(document).on('turbolinks:load', () => {
  const teamStandupsElem = $('#team-standups-container');

  if (teamStandupsElem.length > 0) {
    createTeamStandupConsumers(window.location.pathname.split('/')[2]);
  }
});
