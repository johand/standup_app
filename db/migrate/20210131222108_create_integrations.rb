class CreateIntegrations < ActiveRecord::Migration[6.0]
  def change
    create_table :integrations, id: :uuid do |t|
      t.references :account, type: :uuid, index: true, null: false, foreign_key: true
      t.string :type
      t.jsonb :settings, null: false, default: {}

      t.timestamps
    end

    add_index :integrations, :settings, using: :gin
  end
end
