class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :subject_class
      t.string :subject_action

      t.timestamps null: false
    end
  end
end
