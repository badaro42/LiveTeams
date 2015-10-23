class CreateGeoEntities < ActiveRecord::Migration
  def change
    create_table :geo_entities do |t|
      t.string :name
      t.geometry :latlon, geographic: true, srid: 4326
      t.integer :user_id
      t.text :description

      t.timestamps null: false
    end
  end
end