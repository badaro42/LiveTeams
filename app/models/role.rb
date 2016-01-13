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
  GERIR_EQUIPAS = "Gerir equipas"
  GERIR_MEMBROS_EQUIPA = "Gerir membros de equipas"
  GERIR_EQUIPAS_E_MEMBROS_EQUIPA = "Gerir equipas e membros de equipas"
end