class RegistrationsController < Devise::RegistrationsController
  layout "listings", only: :edit

  def new
    super
  end

  def edit
    super
  end

  def create
    super
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
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


  protected
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end