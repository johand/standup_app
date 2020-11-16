import React, { useReducer } from 'react';
import PropTypes from 'prop-types';
import { useActionCable } from 'use-action-cable';
import { chain, reverse, sortBy } from 'lodash';

const Notifications = props => {
  const channelHandlers = {
    received: data => {
      console.log(`[ActionCable] [Standups]`, data);
      dispatch({ type: 'handleReceivedData', standups: data.json });
    },
  };

  const reducer = (state, action) => {
    switch (action.type) {
      case 'handleDropdownClick':
        return {
          ...state,
          showBadge: false,
          showDropdown: state.showDropdown === '' ? 'show' : '',
        };
      case 'handleReceivedData':
        return { ...state, standups: action.standups, showBadge: true };
    }
  };

  const [{ standups, showBadge, showDropdown }, dispatch] = useReducer(
    reducer,
    {
      standups: props.standups,
      showBadge: false,
      showDropdown: '',
    },
  );

  useActionCable({ channel: 'NotificationsChannel' }, channelHandlers);
  const sortedStandups = chain(standups)
    .sortBy('standup_date')
    .reverse()
    .value();

  return (
    <React.Fragment>
      <a
        className="nav-link"
        href="#"
        onClick={e => {
          e.preventDefault();
          dispatch({ type: 'handleDropdownClick' });
        }}>
        <i className="far fa-bell"></i>
        <span
          className="badge badge-warning navbar-badge"
          style={{ display: showBadge ? 'inline' : 'none' }}>
          NEW
        </span>
      </a>

      <div
        className={`dropdown-menu ${showDropdown} dropdown-alerts dropdown-menu-right`}
        style={{ width: '230px' }}>
        <div id="notification-container">
          <span className="dropdown-item dropdown-header">
            Last {standups.length} notifications
          </span>

          <div className="dropdown-divider"></div>
          {sortedStandups.map(standup => {
            return (
              <React.Fragment key={standup.id}>
                <a
                  className="dropdown-item"
                  href="#"
                  style={{ fontSize: '14px' }}>
                  <span className="float-right text-muted text-sm">
                    {standup.user.name}
                  </span>
                  <i className="fas fa-user mr-2"></i>
                  New Standup!
                  <br />
                  <div className="text-muted text-sm">
                    {standup.standup_date}
                  </div>
                </a>
                <div className="dropdown-divider"></div>
              </React.Fragment>
            );
          })}
        </div>
      </div>
    </React.Fragment>
  );
};

Notifications.propTypes = {
  standups: PropTypes.array,
};

export default Notifications;
