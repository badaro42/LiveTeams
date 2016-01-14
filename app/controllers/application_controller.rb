class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # adiciona estes tipos ao flash, para melhor identificar o sucesso (ou falta dele) da ação
  add_flash_types :success, :warning, :danger, :info

  helper_method :can_perform_action?


  # o utilizador nao tem permissoes para realizar a ação pretendida
  class AccessDenied < StandardError
  end

  # a permissão pretendida nao existe na base de dados
  class PermissionTypo < StandardError
  end

  # ***********************************************************************************
  # ****************************** MÉTODOS DE AUTORIZAÇÃO *****************************
  # ********************** (baseados na biblioteca 'cancancan') ***********************
  # ***********************************************************************************

  # metodo que retorna um booleano consoante o utilizador atual tem ou não
  # permissão para realizar a ação passada como parâmetro
  #
  # ex1: can_perform_action? :update, @user
  # ex2: can_perform_action? :update, Team
  # def can_perform_action?(s_class, s_action, object = nil)
  def can_perform_action?(s_action, s_object)
    arr = check_permission_helper(s_action, s_object)

    # caso o utilizador tenha a permissão, o array não estará vazio, terá sim pelo menos 1 permissão
    can_do = arr.length > 0
  end


  #
  def custom_authorize!(s_action, s_object)
    arr = check_permission_helper(s_action, s_object)

    # o utilizador nao tem permissao para realizar a ação
    if arr.length == 0
      # é levantada uma exceção para ser tratada no controlador
      raise AccessDenied
    end

    # else
    #   # é levantada uma exceção para ser tratada no controlador
    #   raise PermissionTypo
    # end
  end


  private
  def get_user_id_from_object(object)
    o_id = -1
    if object.is_a? User
      o_id = object.id.to_i
    elsif object.is_a? Team
      o_id = object.leader_id.to_i
    elsif object.is_a? GeoEntity
      o_id = object.user_id.to_i
    end
    o_id
  end

  def check_permission_helper(s_action, s_object)
    action_to_check = nil
    class_to_check = nil
    permission_to_check = nil

    object_id = get_user_id_from_object(s_object)
    if object_id != -1
      if object_id != current_user.id
        action_to_check = s_action.to_s

        if action_to_check == "update" || action_to_check == "destroy"
          action_to_check = s_action.to_s + "_all%"
        end

        class_to_check = s_object.class.to_s
      else # o id do objeto é igual ao do utilizador atual
        action_to_check = s_action.to_s + "%"
        class_to_check = s_object.class.to_s
      end
    else
      action_to_check = s_action.to_s
      class_to_check = s_object.to_s
    end

    puts "******************** permission_helper *************************"
    puts action_to_check
    puts class_to_check
    puts "****************************************************************"

    # verifica nas permissoes atuais do utilizador se aquela que pretendemos está presente
    permission_to_check = current_user.permissions.where("subject_class = ? and subject_action LIKE ?",
                                                         class_to_check, action_to_check)
  end


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