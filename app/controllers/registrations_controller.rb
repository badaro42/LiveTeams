class RegistrationsController < Devise::RegistrationsController
  layout "listings", only: :edit

  def new
    super
  end

  def edit
    gon.user_id = @user.id
    gon.current_user_id = current_user.id

    super
  end

  def create
    super

    # o utilizador é nulo quando houve algum erro na inserção
    if !current_user.nil?
      puts "*************************************************"
      puts "*************************************************"
      puts "*************************************************"
      puts "******* TESTE CRIAÇÃO DE UTILIZADOR *************"
      puts "******* TESTE CRIAÇÃO DE UTILIZADOR *************"
      puts "******* TESTE CRIAÇÃO DE UTILIZADOR *************"
      puts "******* TESTE CRIAÇÃO DE UTILIZADOR *************"
      puts "*************************************************"
      puts "*************************************************"
      puts "*************************************************"

      puts current_user.inspect

      # atribuimos o primeiro papel ao utilizador recem-criado
      UserRole.create(user_id: current_user.id, role_id: Role.where(name: current_user.profile).first.id,
                      expiration_date: 10.years.since)
    end
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    # apenas alteramos o perfil do user na BD caso o utilizador o tenha alterado!
    if params[:user][:profile] != @user.profile && !params[:user][:profile].nil?
      update_user_role(params[:user][:profile])
    end

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = @user.update_attributes(account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end

  rescue UpdateFailed
    flash[:error] = "Não pode alterar o seu papel para '" + params[:user][:profile] +
        "' pois é líder de pelo menos uma equipa!"
    redirect_to @user
  end


  # Modified Devise params for user login
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar,
                                 :profile, :phone_number, :latlon)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar,
                                 :profile, :phone_number)
  end

  def after_sign_up_path_for(resource)
    "/"
  end

  def after_inactive_sign_up_path_for(resource)
    "/register"
  end

  # redireciona para a pagina do utilizador apos editar a informação
  def after_update_path_for(resource)
    user_path(resource)
  end

  # recebe como parametro o novo perfil do utilizador
  # faz uma query à BD para obter o papel atual do utilizador, altera-o e volta a gravar o tuplo
  # NOTA: só permite atualizar o perfil de ADMIN ou GESTOR para OPERACIONAL ou BASICO caso o user nao seja lider
  # de nenhum equipa
  def update_user_role(new_role)

    # verificamos se é lider de alguma equipa
    if (@user.profile == Role::ADMINISTRADOR || @user.profile == Role::GESTOR) &&
        (new_role == Role::OPERACIONAL || new_role == Role::BASICO)

      teams_leading = Team.where(leader_id: @user.id)
      if teams_leading.length > 0
        raise UpdateFailed
      end
    end

    curr_profile = UserRole.where(user_id: @user.id, role_id: Role.where(name: @user.profile).first.id).first
    curr_profile.role_id = Role.where(name: new_role).first.id
    curr_profile.save
  end


  protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end