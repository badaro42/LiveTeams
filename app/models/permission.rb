class Permission < ActiveRecord::Base
  has_many :role_permissions
  has_many :roles, through: :role_permissions
  has_many :users, through: :roles

  # as classes disponiveis na aplicação
  # adicionar aqui as constantes caso sejam adicionadas mais classes
  CLASS_USER = "User"
  CLASS_GEO_ENTITY = "GeoEntity"
  CLASS_TEAM = "Team"
  CLASS_TEAM_MEMBER = "TeamMember"
  CLASS_USER_ROLE = "UserRole"

  # as diferentes ações que podem ser executadas sobre os objetos
  # dificilmente serão adicionadas mais constantes, uma vez que estão são as ações CRUD
  ACTION_CREATE = "create"
  ACTION_READ = "read"
  ACTION_UPDATE_OWN = "update_own"
  ACTION_UPDATE_ALL = "update_all"
  ACTION_DESTROY_OWN = "destroy_own"
  ACTION_DESTROY_ALL = "destroy_all"
end
