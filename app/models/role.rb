class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_roles

  has_many :role_permissions
  has_many :permissions, through: :role_permissions

  # papeis básicos
  # NAO MEXER NESTES PAPEIS!!!
  BASICO = "Básico"
  OPERACIONAL = "Operacional"
  GESTOR = "Gestor"
  ADMINISTRADOR = "Administrador"

  # restantes papeis
  # ADICIONAR MAIS PAPEIS AQUI!!!!!!!!!!
  USER_UPDATE_ALL = "Atualizar todos os utilizadores"
  USER_DESTROY_ALL = "Remover todas contas de utilizadores"

  TEAM_CREATE = "Criar novas equipas"
  TEAM_UPDATE_OWN = "Atualizar as próprias equipas"
  TEAM_UPDATE_ALL = "Atualizar todas as equipas"
  TEAM_DESTROY_OWN = "Remover as próprias equipas"
  TEAM_DESTROY_ALL = "Destruir todas as equipas"

  GEO_ENTITY_REMOVE_OWN = "Remover as próprias geo-entidades"
  GEO_ENTITY_REMOVE_ALL = "Remover todas as geo-entidades"
  GEO_ENTITY_CREATE = "Criar novas geo-entidades"

  TEAM_MEMBER_CREATE = "Adicionar membros às equipas"
  TEAM_MEMBER_DESTROY = "Remover membros das equipas"

  MANAGE_TEMPORARY_USER_ROLES = "Adicionar/remover papéis temporários"


  # todos os papeis que existam na base de dados
  # a primeira linha apenas apresenta os 4 papeis principais
  # a segunda linha apenas todos os papeis que estejam na BD
  def self.options_for_select
    order('id').where('id <= ?', 4).map { |e| [e.name, e.name] }
    # order('id').map { |e| [e.name, e.id] }
  end

  def self.remaining_roles_for_select
    order('id').where('id >= ?', 5).map { |e| [e.name, e.id] }
  end

  def self.time_values_for_select
    [
        ["30 minutos", 0.5],
        ["1 hora", 1],
        ["2 horas", 2],
        ["4 horas", 4],
        ["8 horas", 8],
        ["12 horas", 12],
        ["1 dia", 24]
    ]
  end
end