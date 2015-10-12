class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    super

    # @user = User.new(sign_up_params)
    # # @user.avatar = params[:user][:avatar]
    # @user.save

    # respond_with @user

    # super
  end

  def update
    super
  end


# Modified Devise params for user login
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar)
  end

  def after_sign_up_path_for(resource)
    "/"
  end

  def after_inactive_sign_up_path_for(resource)
    "/register"
  end

end