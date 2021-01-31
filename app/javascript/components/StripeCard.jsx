import React from 'react';
import { Elements } from '@stripe/react-stripe-js';
import { loadStripe } from '@stripe/stripe-js';
import { CardSection } from './CardSection';

const stripePromise = loadStripe(window.constants.stripePKey);

export default function StripeCard(props) {
  return (
    <Elements stripe={stripePromise}>
      <CardSection {...props} />
    </Elements>
  );
}
