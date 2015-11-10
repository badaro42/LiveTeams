class AddLocationToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :location_user_id, :integer
    add_column :teams, :latlon, :st_point, geographic: true, srid: 4326
  end
end
