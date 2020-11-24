import React, { useState } from 'react';
import PropTypes from 'prop-types';
import Standup from './Standup';
import { useActionCable } from 'use-action-cable';
import { chain, chunk, reverse, sortBy } from 'lodash';

const Standups = props => {
  const channelParams = getActionCableConfig();
  const { header_display = 'date' } = props;
  const [standups, setStandups] = useState(props.standups);
  const channelHandlers = {
    received: data => {
      console.log(`[ActionCable] [Standups]`, data);
      setStandups(data.json);
    },
  };

  useActionCable(channelParams, channelHandlers);

  const standupChunks = chain(standups)
    .sortBy('standup_date')
    .reverse()
    .chunk(3)
    .value();

  return (
    <React.Fragment>
      {standupChunks.map((standups, i) => {
        return (
          <div key={i} className="row">
            {standups.map(standup => {
              return (
                <Standup
                  key={standup.id}
                  standup={standup}
                  header_display={header_display}
                />
              );
            })}
          </div>
        );
      })}
    </React.Fragment>
  );
};

const getActionCableConfig = () => {
  let data = { date: null };

  const pathArray = window.location.pathname.split('/');
  switch (pathArray[1]) {
    case 't':
      data = {
        ...data,
        channel: 'TeamStandupsChannel',
        team_id: pathArray[2],
        date: getDate(pathArray[4]),
      };
      break;
    case 'account':
      data = {
        ...data,
        channel: 'UserStandupsChannel',
        user_id: pathArray[3],
      };
      break;
  }

  return data;
};

const getDate = date => {
  if (typeof date != 'undefined') {
    return date;
  } else {
    return new Date().toISOString().substring(0, 10);
  }
};

Standups.propTypes = {
  standups: PropTypes.array,
  header_display: PropTypes.string,
};

export default Standups;
