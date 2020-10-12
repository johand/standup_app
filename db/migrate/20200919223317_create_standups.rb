class CreateStandups < ActiveRecord::Migration[6.0]
  def change
    create_table :standups, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.date :standup_date

      t.timestamps
    end
  end
end
