class CreateDaysOfTheWeekMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :days_of_the_week_memberships, id: :uuid do |t|
      t.references :team, type: :uuid, null: false, foreign_key: true
      t.integer :day

      t.timestamps
    end
  end
end
