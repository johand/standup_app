import React from 'react';
import PropTypes from 'prop-types';
import { CardElement } from '@stripe/react-stripe-js';
import { useStripe, useElements } from '@stripe/react-stripe-js';
import './card.css';

const CARD_ELEMENT_OPTIONS = {
  // hidePostalCode: false,

  style: {
    base: {
      color: '#32325d',
      fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
      fontSmoothing: 'antialiased',
      fontSize: '16px',
      '::placeholder': {
        color: '#aab7c4',
      },
    },
    invalid: {
      color: '#fa755a',
      iconColor: '#fa755a',
    },
  },
};

export function CardSection({ url_path, csrf_token, button_text }) {
  const stripe = useStripe();
  const elements = useElements();
  const handleSubmit = async event => {
    event.preventDefault();

    if (!stripe || !elements) {
      return;
    }

    const cardElement = elements.getElement(CardElement);
    const { token, error } = await stripe.createToken(cardElement);
    await postForm({ token, error, url_path, csrf_token });
  };

  return (
    <form onSubmit={handleSubmit}>
      <CardElement options={CARD_ELEMENT_OPTIONS} />
      <button className="btn btn-primary mt-4" type="submit" disabled={!stripe}>
        {button_text}
      </button>
    </form>
  );
}

const postForm = async ({ token, error, url_path, csrf_token }) => {
  if (error) {
    console.log('[error], error');
  } else {
    console.log('[path, token]', url_path, token);
    let formData = useFormData(token);
    await fetch(url_path, {
      headers: {
        'X-CSRF-Token': csrf_token,
      },
      method: 'post',
      body: formData,
    });

    window.Turbolinks.visit('/');
  }
};

const useFormData = token => {
  const formData = new FormData();
  formData.append('plan', location.pathname.split('/')[2]);
  formData.append('stripeToken', token.id);
  return formData;
};

CardSection.propTypes = {
  url_path: PropTypes.string,
  csrf_token: PropTypes.string,
  button_text: PropTypes.string,
};
