class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.references :team, index: true, unique: true
      t.references :user, index: true
      t.boolean :is_leader
      t.timestamps null: false
    end

    add_foreign_key :team_members, :users
    add_foreign_key :team_members, :teams
  end
end
