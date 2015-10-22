class CreateGeoStuffs < ActiveRecord::Migration
  def change
    create_table :geo_stuffs do |t|
      t.string :name
      t.geometry :coords, geographic: true, srid: 4326

      t.timestamps null: false
    end
  end
end
