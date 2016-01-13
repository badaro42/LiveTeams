class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      # t.text :permission_ids, array: true, default: []

      t.timestamps null: false
    end
  end
end
