class Team < ActiveRecord::Base
  has_paper_trail

  has_many :team_members, :dependent => :delete_all
  has_many :users, through: :team_members
  has_many :geo_entities

  belongs_to :user

  attr_accessor :is_leader
  accepts_nested_attributes_for :team_members
  accepts_nested_attributes_for :users

  validates :name, presence: true

  # REVERSE-GEOCODING: agarra nas coordenadas da equipa e devolve a morada
  reverse_geocoded_by :latitude, :longitude

  # apenas invoca o reverse geocoder caso as coordenadas se
  after_validation :reverse_geocode, if: ->(obj){ obj.latlon.present? and obj.latlon_changed? }

  attr_reader :latitude, :longitude

  def users=(users)
    users.reject(&:blank?)
  end

  # devolve a latitude das coordenadas da equipa
  def latitude
    self.latlon.lat if self.latlon
  end

  # devolve a longitude das coordenadas da equipa
  def longitude
    self.latlon.lon if self.latlon
  end

end
