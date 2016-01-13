class Permission < ActiveRecord::Base
  has_many :role_permissions
  has_many :roles, through: :role_permissions

  has_many :users, through: :roles

  # as classes disponiveis na aplicação
  # adicionar aqui as constantes caso sejam adicionadas mais classes
  CLASS_USER = "user"
  CLASS_GEO_ENTITY = "geo_entity"
  CLASS_TEAM = "team"
  CLASS_TEAM_MEMBER = "team_member"

  # as diferentes ações que podem ser executadas sobre os objetos
  # dificilmente serão adicionadas mais constantes, uma vez que estão são as ações CRUD
  ACTION_CREATE = "create"
  ACTION_READ = "read"
  ACTION_UPDATE = "update"
  ACTION_DESTROY = "destroy"
end
