import React from 'react';
import Standups from './Standups';
import { ActionCableProvider } from 'use-action-cable';

export default function StandupsWrapper(props) {
  return (
    <ActionCableProvider url="/cable">
      <Standups {...props} />
    </ActionCableProvider>
  );
}
