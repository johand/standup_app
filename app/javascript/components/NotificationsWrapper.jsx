import React from 'react';
import Notifications from './Notifications';
import { ActionCableProvider } from 'use-action-cable';

export default function NotificationsWrapper(props) {
  return (
    <ActionCableProvider url="/cable">
      <Notifications {...props} />
    </ActionCableProvider>
  );
}
