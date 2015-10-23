class AddAttributesToGeoEntity < ActiveRecord::Migration
  def change
    add_column :geo_entities, :entity_type, :string
    add_column :geo_entities, :radius, :integer
  end
end
