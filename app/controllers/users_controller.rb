class UsersController < ApplicationController
  # before_action :set_user, only: [:show]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  require 'encode_to_json'
  layout "listings"

  def users_to_json
    users_to_json = EncodeToJson::encode_users_to_json(User.where.not(id: current_user.id))
    render json: users_to_json
  end

  def update_location
    current_latlon = current_user.latlon
    gon.update_successful = false

    geographic_factory = RGeo::Geographic.spherical_factory(:srid => 4326)
    new_point = geographic_factory.point(params[:longitude], params[:latitude])
    distance = current_latlon.distance(new_point)

    puts new_point
    puts distance

    # só atualiza a localização se a diferença para a anterior for maior que 20m
    # TODO: deve ser necessário fazer um fine-tunning a este parametro
    # if distance > 20
    current_user.latlon = new_point
    current_user.save

    teams_in_need_of_update = []

    # atualizar a posição de todas as equipas que tenham este user como responsavel por atualizar a localização
    teams = Team.where(location_user_id: params[:user_id].to_i)
    teams.each do |team|
      teams_in_need_of_update.push(team.id)

      team.latlon = new_point
      team.save
    end
    # end

    # todas as equipas cujo utilizador é responsavel pela posição sao introduzidas neste array
    gon.teams_user_update_position = teams_in_need_of_update

    puts "IDS DAS EQUIPAS QUE TÊM COMO RESPONSAVEL ESTE GAJO:"
    puts gon.teams_user_update_position.inspect

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def get_user_profile
    user_profile = User.find(params[:user_id].to_s).profile
    render json: user_profile.to_json
  end


  def new
    redirect_to root_path
  end

  def index
    custom_authorize! :read, User

    @filterrific = initialize_filterrific(
        User,
        params[:filterrific],
        select_options: {
            sorted_by: User.options_for_sorted_by,
            with_role_name: Role.options_for_select
        },
        persistence_id: false
    ) or return

    @users = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end

  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return

  rescue AccessDenied
    flash[:error] = "Não tem permissão para visualizar utilizadores."
    redirect_to root_path
  end

  def show
    custom_authorize! :read, User

    puts "ESTOU NO SHOW E PASSEI A CENA DA PERMISSAO!"

    if @user.nil?
      flash[:error] = "O utilizador que procura nao existe!"
      redirect_to users_url
    else
      # variaveis que podem ser acedidas no javascript
      gon.user_id = @user.id
      gon.current_user_id = current_user.id
      gon.curr_user_pos = @user.latlon

      # uniao das equipas que criou com as que esta inserido
      # pode ter criado uma equipa e nao estar inserido na mesma, p.e.
      @teams_belonging_or_created = @user.teams | @user.teams_created
    end

  rescue AccessDenied
    flash[:error] = "Não tem permissão para visualizar utilizadores."
    redirect_to root_path
  end

  # obtemos primeiro o user pois há 2 endereços que são servidos por este metodo:
  # /account/edit e /users/:id/edit
  def edit
    if params[:id] == nil
      @user = User.find(current_user.id)
    else
      gon.user_id = @user.id
      gon.current_user_id = current_user.id

      @user = User.find(params[:id])
    end

    custom_authorize! :update, @user

  rescue AccessDenied
    flash[:error] = "Não tem permissão para editar o perfil deste utilizador."
    redirect_to @user
  end

  def update
    custom_authorize! :update, @user

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    # apenas alteramos o perfil do user na BD caso o utilizador o tenha alterado!
    if params[:user][:profile] != @user.profile && !params[:user][:profile].nil?
      update_user_role(params[:user][:profile])
    end

    respond_to do |format|
      if @user.update(account_update_params)
        format.html { redirect_to @user, success: "O utilizador '" + @user.full_name + "' foi atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, error: "Ocorreu um erro ao atualizar o utilizador!" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  rescue UpdateFailed
    flash[:error] = "Não pode alterar o seu papel para '" + params[:user][:profile] +
        "' pois é líder de pelo menos uma equipa!"
    redirect_to @user

  rescue AccessDenied
    flash[:error] = "Não tem permissão para editar o perfil deste utilizador."
    redirect_to @user
  end

  # remover o utilizador do sistema
  # ao remover a conta do utilizador, todas as entradas do utilizador na tabela "team_members" são removidas
  def destroy
    custom_authorize! :destroy, @user

    is_leader_of_any_team = @user.leading_teams.length > 0
    is_in_charge_of_any_team_location = @user.teams_in_charge_of_location.length > 0

    puts "É LIDER DE ALGUMA EQUIPA?"
    puts is_leader_of_any_team
    puts "É RESPONSAVEL PELA LOCALIZAÇAO DE ALGUMA EQUIPA?"
    puts is_in_charge_of_any_team_location

    # L - lider de equipa; R - responsavel pela localização de equipa
    # apenas é possivel remover o utilizador caso ele nao seja lider ou responsavel pela localização de uma equipa
    if is_leader_of_any_team || is_in_charge_of_any_team_location # L || R
      custom_error = "Não é possível remover o utilizador '" + @user.full_name + "' uma vez que este é "
      if is_leader_of_any_team # L-true
        if is_in_charge_of_any_team_location # L-true, R-true
          custom_error += "líder e responsável pela localização de pelo menos uma equipa."
        else # L-true, R-false
          custom_error += "líder de pelo menos uma equipa."
        end
      else # L-false, R-true
        custom_error += "responsável pela localização de pelo menos uma equipa."
      end

      flash[:error] = custom_error
      redirect_to @user
    else # vamos então remover o utilizador
      @user.destroy

      respond_to do |format|
        if @user.destroyed?
          message_to_show = ""
          if current_user == @user
            message_to_show = "A sua conta foi removida com sucesso. Até sempre :'("
          else
            message_to_show = "A conta do utilizador '" + @user.full_name + "' foi removida com sucesso!"
          end

          flash[:success] = message_to_show
          format.html { redirect_to users_path }
        else
          flash[:error] = "Ocorreu um erro ao remover o utilizador!"
          format.html { redirect_to @user }
        end
      end
    end

  rescue AccessDenied
    flash[:error] = "Não tem permissão para remover este utilizador."
    redirect_to @user
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    if User.exists?(params[:id].to_i)
      @user = User.find(params[:id])
    end
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

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar,
                                 :profile, :phone_number)
  end

end
