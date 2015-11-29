class AddLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :latlon, :st_point, geographic: true, srid: 4326, null: false
  end
end
