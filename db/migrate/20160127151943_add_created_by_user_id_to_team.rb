class AddCreatedByUserIdToTeam < ActiveRecord::Migration
  def change
    add_reference :teams, :created_by_user, index: true
    add_foreign_key :teams, :users, column: :created_by_user_id
  end
end
