class TeamGeoEntity < ActiveRecord::Base
  belongs_to :team
  belongs_to :geo_entity

  validates_uniqueness_of :team_id, :scope => [:geo_entity_id]
end
