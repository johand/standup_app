class CreateTeamMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :team_memberships, id: :uuid do |t|
      t.references :team, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
