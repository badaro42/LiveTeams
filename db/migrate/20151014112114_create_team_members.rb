class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.integer :team_id
      t.integer :user_id
      t.boolean :is_leader

      t.timestamps null: false
    end
  end
end
