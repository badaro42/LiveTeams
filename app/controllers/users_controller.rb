class UsersController < ApplicationController
  # before_action :set_user, only: [:show]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  layout "listings"

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

    @users = User.all.order(first_name: :asc, last_name: :asc)

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

      @user_teams = @user.teams
      @user_entities = @user.geo_entities
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

  def destroy
    custom_authorize! :destroy, @user

    respond_to do |format|
      if @user.destroy
        format.html { redirect_to root_path, success: "A sua conta foi removida com sucesso. Até sempre :'(" }
      else
        format.html { render nothing: true, error: "Ocorreu um erro ao remover o utilizador!" }
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
