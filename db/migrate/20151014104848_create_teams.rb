class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.st_point :latlon_highlight, geographic: true, srid: 4326
      t.timestamps null: false
    end
  end
end
