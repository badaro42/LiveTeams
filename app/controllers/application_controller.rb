class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # adiciona estes tipos ao flash, para melhor identificar o sucesso (ou falta dele) da ação
  add_flash_types :success, :warning, :danger, :info


  # o utilizador nao tem permissoes para realizar a ação pretendida
  class AccessDenied < StandardError
  end

  # a permissão pretendida nao existe na base de dados
  class PermissionTypo < StandardError
  end

  #
  def custom_authorize!(s_class, s_action)
    desired_permission = Permission.where(subject_class: s_class, subject_action: s_action).first

    # apenas é nulo caso não exista essa permissão na BD -> pode ser erro de escrita
    # p.e.: escrever "utilizadores" em vez de "users", ou "criar" em vez de "create"
    if !desired_permission.nil?
      has_permission = current_user.permissions.include?(desired_permission)

      # o utilizador nao tem permissao para realizar a ação
      if !has_permission
        # é levantada uma exceção para ser tratada no controlador
        raise AccessDenied
      end
    else
      # é levantada uma exceção para ser tratada no controlador
      raise PermissionTypo
    end
  end

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