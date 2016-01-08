class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # adiciona estes tipos ao flash, para melhor identificar o sucesso (ou falta dele) da ação
  add_flash_types :success, :warning, :danger, :info

  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to root_path
  # end

  private
  def after_sign_in_path_for(resource)
    "/"
  end

  def after_sign_out_path_for(resource)
    "/login"
  end

  # # Overwriting the sign_out redirect path method
  # def after_sign_out_path_for(resource)
  #   root_path(resource)
  # end
  #
  # # Overwriting the sign_up redirect path method
  # def after_sign_up_path_for(resource)
  #   root_path(resource)
  # end

end