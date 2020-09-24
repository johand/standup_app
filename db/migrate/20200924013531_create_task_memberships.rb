class CreateTaskMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :task_memberships, id: :uuid do |t|
      t.references :task, type: :uuid, null: false, foreign_key: true
      t.references :standup, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
