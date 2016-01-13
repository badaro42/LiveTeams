class Permission < ActiveRecord::Base
  has_many :role_permissions
  has_many :roles, through: :role_permissions
  has_many :users, through: :roles
end
