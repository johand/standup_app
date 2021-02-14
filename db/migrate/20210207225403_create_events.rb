class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events, id: :uuid do |t|
      t.string :type
      t.references :team, type: :uuid, null: false, foreign_key: true
      t.string :user_name
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :event_name
      t.text :event_body
      t.string :event_id
      t.jsonb :event_data, default: {}
      t.datetime :event_time

      t.timestamps
    end

    add_index :events, :event_data, using: :gin
    add_index :events, :type
    add_index :events, :user_name
    add_index :events, :event_id
  end
end
