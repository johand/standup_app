import React, { useState } from 'react';
import PropTypes from 'prop-types';
import Standup from './Standup';
import { chain, chunk, reverse, sortBy } from 'lodash';

const Standups = ({ standups }) => {
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
              return <Standup key={standup.id} standup={standup} />;
            })}
          </div>
        );
      })}
    </React.Fragment>
  );
};

Standups.propTypes = {
  standups: PropTypes.array,
};

export default Standups;
