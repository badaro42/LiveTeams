class Team < ActiveRecord::Base
  has_paper_trail


  filterrific default_filter_params: {sorted_by: 'name_asc'},
              available_filters: %w[
                  sorted_by
                  search_team_query
                  search_team_member_query
                  with_role_name
              ]

  # will_paginate - numero de elementos por pagina
  self.per_page = 5


  has_many :team_members, dependent: :delete_all
  has_many :users, through: :team_members

  has_many :team_geo_entities, dependent: :delete_all
  has_many :geo_entities, through: :team_geo_entities

  belongs_to :user

  # attr_accessor :leader_profile
  accepts_nested_attributes_for :team_members
  accepts_nested_attributes_for :users

  validates :name, presence: true

  # REVERSE-GEOCODING: agarra nas coordenadas da equipa e devolve a morada
  reverse_geocoded_by :latitude, :longitude

  # apenas invoca o reverse geocoder caso as coordenadas se
  after_validation :reverse_geocode, if: ->(obj) { obj.latlon.present? and obj.latlon_changed? }

  attr_reader :latitude, :longitude


  # o escopo para quando o utilizador insere uma pesquisa
  scope :search_team_query, lambda { |query|
    return nil if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 1
    where(
        terms.map {
          or_clauses = [
              "LOWER(name) LIKE ?"
          ].join(' OR ')
          "(#{ or_clauses })"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  # o escopo para quando o utilizador insere uma pesquisa
  scope :search_team_member_query, lambda { |query|
    return nil if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 2

    where(
        terms.map {
          or_clauses = [
              "LOWER(users.first_name) LIKE ?",
              "LOWER(users.last_name) LIKE ?"
          ].join(' OR ')
          "(#{ or_clauses })"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conditions }.flatten
    ).joins(:team_members).joins(:users).group("teams.id")
  }

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^created_at_/
        order("teams.created_at #{ direction }")
      when /^name_/
        order("LOWER(teams.name) #{ direction }")
      # when /^country_name_/
      #   order("LOWER(countries.name) #{ direction }").includes(:country)
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
        ['Nome (a-z)', 'name_asc'],
        ['Nome (z-a)', 'name_desc'],
        ['Data de criação (mais recente primeiro)', 'created_at_desc'],
        ['Data de criação (mais antigo primeiro)', 'created_at_asc']
    # ['Perfil (a-z)', 'country_name_asc']
    ]
  end


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
