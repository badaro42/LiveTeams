class AddCategoryIdToGeoEntity < ActiveRecord::Migration
  def change
    add_reference :geo_entities, :category, index: true, foreign_key: true
  end
end
