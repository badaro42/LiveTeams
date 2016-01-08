class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :set_team_geo_entities, only: [:show, :destroy]
  before_filter :authenticate_user!
  # load_and_authorize_resource

  require 'encode_to_json'
  layout "listings"

  def teams_to_json
    teams_to_json = EncodeToJson::encode_teams_to_json(Team.all)
    render json: teams_to_json
  end

  # recebe um par de coordenadas e devolve a morada dessas mesmas coordenadas
  def reverse_geocode_coords
    require 'geocoder'

    address = Geocoder.address(params[:latitude] + ", " + params[:longitude])
    render json: address.to_json
  end

  # GET /teams
  # GET /teams.json
  # no caso de o pedido ser ajax para popular a dropdown de equipas, vamos verificar as equipas
  # a que o utilizador pertence
  def index
    # dropdown das equipas no mapa
    if params[:origin] === "dropdown_teams"
      if current_user.profile === User::ADMINISTRADOR || current_user.profile === User::GESTOR
        @teams = Team.all.order(id: :asc)
        # elsif current_user.profile === User::OPERACIONAL
        # TODO: APENAS PARA TESTES!!!! remover a condição abaixo e colocar a que esta comentada
      elsif current_user.profile === User::OPERACIONAL || current_user.profile === User::BASICO
        tm = TeamMember.where(user_id: current_user.id).map(&:team_id).flatten
        @teams = Team.find(tm)
      end
    else
      @teams = Team.all.order(id: :asc)
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    if @team.nil?
      puts "equipa nao existe !!!!!!!!!!!!!!!!!!!!!!!!"
      flash[:error] = "A equipa que procura nao existe!"
      redirect_to teams_url
    else
      set_users_for_multiple_select("show")

      gon.push({
                   highlight_latlon: @team.latlon_highlight,
                   current_latlon: @team.latlon,
                   current_team_id: @team.id,
                   team_versions: []
               })

      @team.versions.each do |version|
        gon.team_versions.push(version.reify)
      end

      # obtem o utilizador que é lider da equipa
      team_leader_entry = @team.team_members.where(is_leader: true).first
      @team_leader = @team.users.where(id: team_leader_entry.user_id).first

      # utilizador responsavel por atualizar a posição da equipa
      @location_user = User.find(@team.location_user_id)
    end
  end

  # GET /teams/new
  def new
    authorize! :create, Team

    @team = Team.new
    @users_in_team = @team.users

    set_users_for_multiple_select("new")

  rescue CanCan::AccessDenied
    flash[:error] = "Não tem permissão para criar equipas."
    redirect_to teams_path
  end

  # GET /teams/1/edit
  def edit
    authorize! :update, Team

    if @team.nil?
      flash[:error] = "A equipa que procura não existe!"
      redirect_to teams_url
    else
      @team_leader = TeamMember.find_by(team_id: @team.id, is_leader: true)
      if @team_leader.user_id == current_user.id || current_user.profile == User::ADMINISTRADOR
        gon.current_team_id = @team.id
        gon.users_in_team = set_users_in_team

        @users_in_team = @team.users # para as dropdowns de escolha de lider/responsavel localização
        set_users_for_multiple_select("new")
      else
        flash[:error] = "Não tem permissão para editar equipas."
        redirect_to @team
      end
    end

  rescue CanCan::AccessDenied
    flash[:error] = "Não tem permissão para editar equipas."
    redirect_to @team
  end

  # POST /teams
  # POST /teams.json
  def create
    authorize! :create, Team

    @team = Team.new(team_params)

    # utilizador responsavel pela localização
    # vamos buscar a localização para esse utilizador e introduzimos na equipa
    @team.latlon = User.find(params[:team][:location_user_id]).latlon

    respond_to do |format|
      if @team.save
        # adicionar os vários membros da equipa, colocar aqui um FOR!
        # todos os elementos sao adicionados como nao sendo lider
        params[:team][:users].each do |u_id|
          if u_id.to_i > 0
            # é o lider, adiciona-se com o parametro a true
            if u_id == params[:team][:is_leader]
              team_member = TeamMember.new(:user_id => u_id.to_i, :team_id => @team.id, :is_leader => true)
            else
              team_member = TeamMember.new(:user_id => u_id.to_i, :team_id => @team.id, :is_leader => false)
            end
            team_member.save
          end
        end

        format.html { redirect_to @team, success: "A equipa '" + @team.name + "' foi criada com sucesso!" }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, error: "Ocorreu um erro ao criar uma nova equipa!" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end

  rescue CanCan::AccessDenied
    flash[:error] = "Não tem permissão para criar equipas."
    redirect_to teams_path
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    authorize! :update, Team

    respond_to do |format|
      # verificamos se o utilizador responsavel pela posição foi alterado
      # se sim, atualizamos a posição atual da equipa
      if @team.location_user_id != params[:team][:location_user_id].to_i
        @team.location_user_id = params[:team][:location_user_id].to_i
        @team.latlon = User.find(params[:team][:location_user_id].to_i).latlon
        params[:team].delete(:location_user_id)
      end

      @team.updated_at = Time.now
      if @team.update(team_params)
        # começamos por remover todas as entradas da tabela para esta equipa
        TeamMember.delete_all(["team_id = ?", @team.id.to_i])

        # por fim, adicionamos novamente os membros da equipa, bem como qual o capitão
        params[:team][:users].each do |u_id|
          new_id = u_id.to_i
          leader_id = params[:team][:is_leader].to_i
          if new_id === leader_id
            team_member = TeamMember.new(:user_id => new_id, :team_id => @team.id, :is_leader => true)
          else
            team_member = TeamMember.new(:user_id => new_id, :team_id => @team.id, :is_leader => false)
          end
          team_member.save
        end

        format.html { redirect_to @team, success: "A equipa '" + @team.name + "' foi atualizada com sucesso!" }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, error: "Ocorreu um erro ao atualizar a equipa!" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end

  rescue CanCan::AccessDenied
    flash[:error] = "Não tem permissão para editar equipas."
    redirect_to @team
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    authorize! :destroy, Team

    team_name = @team.name
    team_id = @team.id.to_s
    @team.destroy # elimina a equipa. se o delete for bem sucedido, removemos os ids da equipa das geo-entidades

    if @team.destroyed?
      @team_geo_entities.each do |geo_entity|
        geo_entity.team_ids.delete(team_id)
      end

      respond_to do |format|
        format.html { redirect_to teams_url, success: "A equipa '" + team_name + "' foi removida com sucesso!" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to teams_url, success: "Ocorreu um erro a remover a equipa!" }
        format.json { head :no_content }
      end
    end

  rescue CanCan::AccessDenied
    flash[:error] = "Não tem permissão para eliminar equipas."
    redirect_to @team
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    if Team.exists?(params[:id].to_i)
      @team = Team.find(params[:id])
    end
  end

  # agrega todas as entidades que estejam associadas a esta equipa
  # este metodo só executa o codigo caso a equipa nao seja nula!
  def set_team_geo_entities
    unless @team.nil?
      @team_geo_entities = GeoEntity.find_by_sql("select * from geo_entities where '" +
                                                     @team.id.to_s + "' = ANY(team_ids);")
    end
  end

  # injecta os utilizadores que estao na equipa na variavel 'gon'
  # de forma a que no javascript, quando a acção 'edit' é invocada
  def set_users_in_team
    arr_to_ret = []
    members_ids = TeamMember.where(team_id: @team.id).select(:user_id)
    User.where(id: members_ids).order(first_name: :asc, last_name: :asc).each do |user|
      arr_to_ret.push(user.id)
    end
    arr_to_ret
  end

  # retorna o array de utilizadores ja ordenados por categoria
  def set_users_for_multiple_select(action)
    users_arr = []
    values_for_select = [["Administrador", []], ["Gestor", []], ["Operacional", []]]

    if action == "new" || action == "edit"
      users_arr = User.all
    elsif action == "show"
      members_ids = TeamMember.where(team_id: @team.id).select(:user_id)
      users_arr = User.where.not(id: members_ids).order(first_name: :asc, last_name: :asc)
    end

    values_for_select = get_users_by_profile(users_arr, values_for_select, 0, User::ADMINISTRADOR)
    values_for_select = get_users_by_profile(users_arr, values_for_select, 1, User::GESTOR)
    values_for_select = get_users_by_profile(users_arr, values_for_select, 2, User::OPERACIONAL)

    @users_for_select = values_for_select
  end

  # para cada perfil, coloca os utilizadores dentro do array para depois apresentar no select multiplo
  def get_users_by_profile(users_arr, return_arr, index, profile)
    users_arr.where(profile: profile).each do |user|
      elem = []
      elem.push(user.full_name)
      elem.push(user.id)
      return_arr[index][1].push(elem)
    end
    return_arr
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :latlon_highlight, :location_user_id, :is_leader, users: [:id])
  end

end
