class AddIntegrationSettingsToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :integration_settings, :jsonb, null: false, default: {}
    add_index :teams, :integration_settings, using: :gin
  end
end
