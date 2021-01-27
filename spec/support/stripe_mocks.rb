# frozen_string_literal: true

module StripeMocks
  def stripe_mock_customer_success
    stub_request(:post, %r{https://api.stripe.com/v1/customers\w*})
      .to_return(body: { id: '1' }.to_json)
  end

  def stripe_mock_subscription_success
    stub_request(:post, %r{https://api.stripe.com/v1/subscriptions\w*})
      .to_return(
        body: {
          id: 'sub_H2vySBdpRqcHoi',
          start_date: 1_586_160_915,
          status: 'trialing'
        }.to_json
      )
  end

  def stripe_mock_plan_list(plans = [])
    stub_request(:get, 'https://api.stripe.com/v1/plans?limit=20')
      .to_return(body: { object: 'list',
                         data: plans,
                         url: '/v1/plans',
                         has_more: false }.to_json)
  end

  def stripe_mock_plan_delete(plan_id)
    stub_request(:delete, "https://api.stripe.com/v1/plans/#{plan_id}")
      .to_return(body: { id: plan_id, object: 'plan', deleted: true }.to_json)
  end

  def stripe_mock_plan_create_success(plan_id)
    stub_request(:post, 'https://api.stripe.com/v1/plans')
      .with(body: hash_including({ id: plan_id }))
      .to_return(body: { id: plan_id,
                         object: 'plan',
                         active: true,
                         product: 'prod_89fehjkwef' }.to_json)
  end

  def stripe_mock_charge_list(charges = [])
    stub_request(:get, %r{https://api.stripe.com/v1/charges\?customer=\w*})
      .to_return(body: { object: 'list',
                         data: charges,
                         url: '/v1/charges',
                         has_more: false }.to_json)
  end

  def stripe_mock_get_customer(customer = '1')
    stub_request(:get, "https://api.stripe.com/v1/customers/#{customer}")
      .to_return(body: { id: '1' }.to_json)
  end

  def stripe_mock_get_subscription(subscription = '1')
    stub_request(:get, "https://api.stripe.com/v1/subscriptions/#{subscription}")
      .to_return(body: { id: 'sub_H2vy9P9cSDJWPU', items: { data: [{ id: '1' }] } }.to_json)
  end

  def stripe_get_token
    stub_request(:get, %r{https://api.stripe.com/v1/tokens\w*})
      .to_return(body: { id: 'tok_1GUSzKJqqM7ldLAbiRj4x7nQ',
                         card: { id: 'card_1q2w3e4r5t',
                                 brand: 'Visa',
                                 last4: '4242',
                                 exp_month: 8,
                                 exp_year: 2021 } }.to_json)
  end

  def stripe_mock_subscription_delete
    stub_request(:delete, %r{https://api.stripe.com/v1/subscriptions\w*})
      .to_return(body: { id: 'sub_H2vy9P9cSDJWPU', status: 'canceled' }.to_json)
  end

  def stripe_mock_webhook(event_name, subscription_id,
                          data = nil, merge_data = nil)
    data ||= {
      id: 'evt_00000000000000',
      object: 'event',
      type: event_name,
      data: { object: { id: subscription_id, object: 'subscription', subscription: subscription_id } }
    }

    data&.dig(:data, :object)&.merge!(merge_data) if merge_data
    stub_request(:get, %r{https://api.stripe.com/v1/events\w*})
      .to_return(
        body: data.to_json
      )

    event = double('Stripe::Event', data)
    event
  end
end
