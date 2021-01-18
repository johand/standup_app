class CreateStripeWebhooks < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_webhooks, id: :uuid do |t|
      t.string :stripe_event_id

      t.timestamps
    end

    add_index :stripe_webhooks, :stripe_event_id
  end
end
