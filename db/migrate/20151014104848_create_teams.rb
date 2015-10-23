class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.st_point :latlon, geographic: true, srid: 4326

      t.timestamps null: false
    end
  end
end
