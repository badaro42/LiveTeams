class AddLocationToTeam < ActiveRecord::Migration
  def change
    add_reference :teams, :location_user, index: true
    add_foreign_key :teams, :users, column: :location_user_id

    add_column :teams, :latlon, :st_point, geographic: true, srid: 4326
  end
end
