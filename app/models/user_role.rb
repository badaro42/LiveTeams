class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  validates_uniqueness_of :role_id, :scope => [:user_id]

  filterrific default_filter_params: {},
              available_filters: %w[
                  with_role_name
                  search_username_query
                  with_team
              ]

end
