class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  # filterrific default_filter_params: {sorted_by: 'name_asc'},
  #             available_filters: %w[
  #                 with_role_name
  #                 search_username_query
  #                 with_team
  #             ]

  filterrific default_filter_params: {},
              available_filters: %w[
                  with_role_name
                  search_username_query
                  with_team
              ]

  # o escopo para quando o utilizador insere uma pesquisa
  # scope :search_username_query, lambda { |query|
  #   return nil if query.blank?
  #   # condition query, parse into individual keywords
  #   terms = query.downcase.split(/\s+/)
  #   # replace "*" with "%" for wildcard searches,
  #   # append '%', remove duplicate '%'s
  #   terms = terms.map { |e|
  #     (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  #   }
  #   # configure number of OR conditions for provision
  #   # of interpolation arguments. Adjust this if you
  #   # change the number of OR conditions.
  #   num_or_conditions = 2
  #
  #   select(
  #       User.all
  #   ).where(
  #       terms.map {
  #         or_clauses = [
  #             "LOWER(users.first_name) LIKE ?",
  #             "LOWER(users.last_name) LIKE ?"
  #         ].join(' OR ')
  #         "(#{ or_clauses })"
  #       }.join(' AND '),
  #       *terms.map { |e| [e] * num_or_conditions }.flatten
  #   )
  # }
  #





end
