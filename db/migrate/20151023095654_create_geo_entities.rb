class CreateGeoEntities < ActiveRecord::Migration
  def change
    create_table :geo_entities do |t|
      t.string :name, null: false
      t.geometry :latlon, geographic: true, srid: 4326, null: false
      t.references :user, index: true, null: false, foreign_key: true
      t.text :description
      t.timestamps null: false
    end

    # add_foreign_key :geo_entities, :users
  end
end