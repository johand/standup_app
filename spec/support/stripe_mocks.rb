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
end
