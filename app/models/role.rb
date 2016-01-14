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
  REMOVER_GEO_ENTIDADES = "Remover geo-entidades"
  REMOVER_UTILIZADORES = "Remover utilizadores"
  GERIR_EQUIPAS_BASIC = "Gerir equipas (apenas permite editar e remover as equipas criadas pelo utilizador)"
  GERIR_EQUIPAS_GOD_MODE = "Gerir equipas (controlo absoluto sobre todas as equipas)"
  GERIR_MEMBROS_EQUIPA = "Gerir membros de equipas"
  GERIR_EQUIPAS_E_MEMBROS_EQUIPA = "Gerir equipas e membros de equipas"
  EDITAR_TODOS_UTILIZADORES = "Editar todos os utilizadores"
  EDITAR_TODAS_EQUIPAS = "Editar todas as equipas"
end