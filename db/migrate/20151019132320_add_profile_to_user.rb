class AddProfileToUser < ActiveRecord::Migration
  def change
    add_column :users, :profile, :string, null: false
  end
end
