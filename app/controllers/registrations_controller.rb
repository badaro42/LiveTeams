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

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    # apenas alteramos o perfil do user na BD caso o utilizador o tenha alterado!
    if params[:user][:profile] != @user.profile
      puts '\nalterar o perfil do user na base de dados!!!!!!!!!!\n'
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
  def update_user_role(new_role)
    curr_profile = UserRole.where(user_id: @user.id, role_id: Role.where(name: @user.profile).first.id).first
    curr_profile.role_id = Role.where(name: new_role).first.id
    curr_profile.save
  end


  protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end