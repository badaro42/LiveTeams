class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # list of abilites (CRUD):
    # :create - pode criar objetos;
    # :read - apenas pode aceder ao objeto;
    # :update - pode atualizar a info do objeto;
    # :destroy - pode eliminar o objeto da BD.
    #
    # :manange - todas as ações disponíveis sobre o objeto

    # Define User abilities
    if user.is? User::ADMINISTRADOR
      # este gajo faz tudo
      # excepto atualizar geo-entidades e membros e destruir utilizadores
      can :manage, Team
      can [:create, :read, :destroy], [GeoEntity, TeamMember]
      can [:read, :update, :destroy], User

    elsif user.is? User::GESTOR
      # pode alterar as equipas, os membros das mesmas e as geo-entidades
      # só nao pode remover utilizadores, apenas atualizar o perfil
      # can :manage, Team
      # can :manage, TeamMember
      # can [:create, :read, :destroy], GeoEntity
      # can [:read, :update], User

      can :manage, Team
      can [:create, :read, :destroy], [GeoEntity, TeamMember]
      can :read, User
      can [:update, :destroy], User, :id => user.id # apenas pode editar e remover o seu perfil


    elsif user.is? User::OPERACIONAL
      # pode criar novas geo-entidades, mas não as pode remover
      # pode atualizar o seu perfil, excepto alterar o nivel na hierarquia
      # apenas pode aceder às equipas e aos seus membros, não pode alterar nada
      can :read, [Team, TeamMember]
      can [:create, :read], GeoEntity
      can :read, User
      can [:update, :destroy], User, :id => user.id

    elsif user.is? User::BASICO
      # o basico apenas pode ver a info, sem mudar nada
      # excepção feita para o seu perfil, que pode editar (apenas info básica e avatar)
      can :read, [Team, GeoEntity, TeamMember]
      can :read, User
      can [:update, :destroy], User, :id => user.id
    end
  end

end
