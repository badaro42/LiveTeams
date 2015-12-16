class GeoEntity < ActiveRecord::Base
  has_paper_trail

  MARKER = "marker"
  POLYLINE = "polyline"
  POLYGON = "polygon"
  CIRCLE = "circle"
  RECTANGLE = "rectangle"

  TYPES = [MARKER, POLYLINE, POLYGON, CIRCLE, RECTANGLE]
  validates_inclusion_of :entity_type, :in => TYPES

  belongs_to :user
  belongs_to :team

  validates :user_id, presence: true
  validates :name, presence: true
  validates :latlon, presence: true
  validates :description, presence: true
  validates :entity_type, presence: true
  validates :radius, presence: true
end