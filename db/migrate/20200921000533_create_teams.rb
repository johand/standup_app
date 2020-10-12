class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name
      t.references :account, type: :uuid, null: false, foreign_key: true
      t.string :timezone
      t.boolean :has_reminder
      t.boolean :has_recap
      t.time :reminder_time
      t.time :recap_time

      t.timestamps
    end

    add_index :teams, %i[has_reminder reminder_time]
    add_index :teams, %i[has_recap recap_time]
  end
end
