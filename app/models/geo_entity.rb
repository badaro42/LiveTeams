class GeoEntity < ActiveRecord::Base
  # MARKER = "marker"
  # POLYLINE = "polyline"
  # POLYGON = "polygon"
  # CIRCLE = "circle"
  # RECTANGLE = "rectangle"
  #
  # ALL_TYPES = [MARKER, POLYLINE, POLYGON, CIRCLE, RECTANGLE]
  #
  # validates_inclusion_of :type, :in => ALL_TYPES

  belongs_to :user
end