class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      # t.references :user, :leader_id, index: true, foreign_key: true
      t.st_point :latlon_highlight, geographic: true, srid: 4326
      t.timestamps null: false
    end

    add_reference :teams, :leader, index: true
    add_foreign_key :teams, :users, column: :leader_id
  end
end
