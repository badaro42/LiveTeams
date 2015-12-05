class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :set_all_users, only: [:new, :edit]
  before_action :set_users_not_in_this_team, only: [:show]
  before_filter :authenticate_user!

  layout "listings"

  def teams_to_json
    require 'rgeo'
    require 'rgeo-geojson'

    # apenas carrega as equipas que tenham localização
    # equipas sem localização dava merda no mapeamento para json
    teams = Team.all

    # puts "EQUIPAS NO SISTEMA!!!!!!"
    # puts teams

    # cria a fabrica de entidades
    factory = RGeo::GeoJSON::EntityFactory.instance
    # puts factory

    # dps de obter todas as equipas do servidor, mapeia-as num objeto de forma a que sejam correctamente
    # transformadas em json
    mapped_teams = factory.map_feature_collection(teams) {
        |f| factory.feature(User.find(f.location_user_id).latlon, nil,
                            {name: f.name, f_id: f.id, location_user_id: f.location_user_id,
                             created_at: f.created_at, updated_at: f.updated_at,
                             location_user_name: User.find(f.location_user_id).full_name,
                             leader_name: User.find(TeamMember.where(team_id: f.id, is_leader: true)
                                                        .first.user_id).full_name,
                             leader_id: User.find(TeamMember.where(team_id: f.id, is_leader: true)
                                                      .first.user_id).id})
    }

    # puts mapped_teams

    # dps do mapeamento, s�o enviadas para a fabrica que trata da transforma��o
    # para json para serem apresentadas no mapa
    teams_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_teams)

    # puts teste
    render json: teams_to_json
  end

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all.order(id: :asc)
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    if @team.nil?
      flash[:error] = "A equipa que procura nao existe!"
      redirect_to teams_url
    else
      gon.highlight_latlon = @team.latlon_highlight
      gon.current_latlon = @team.latlon
      gon.current_team_id = @team.id
      gon.team_versions = []

      @team.versions.each do |version|
        gon.team_versions.push(version.reify)
      end

      # obtem o utilizador que é lider da equipa
      team_leader_entry = @team.team_members.where(is_leader: true).first
      @team_leader = @team.users.where(id: team_leader_entry.user_id).first

      # utilizador responsavel por atualizar a posição da equipa
      @location_user = User.find(@team.location_user_id)

      # devolve todas as geo-entidades que tenham o id da equipa
      @team_geo_entities = GeoEntity.find_by_sql("select * from geo_entities where '" +
                                                     @team.id.to_s + "' = ANY(team_ids);")
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
    @users_in_team = @team.users
  end

  # GET /teams/1/edit
  def edit
    if @team.nil?
      flash[:error] = "A equipa que procura não existe!"
      redirect_to teams_url
    else
      @users_in_team = @team.users
      @team_leader = TeamMember.find_by(team_id: @team.id, is_leader: true)

      if @team_leader.user_id == current_user.id || current_user.profile == User::ADMINISTRADOR
        puts "PODE EDITAR"
      else
        flash[:error] = "Não tem permissões para realizar essa ação!"
        redirect_to teams_url
      end
    end
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    # utilizador responsavel pela localização
    # vamos buscar a localização para esse utilizador e introduzimos na equipa
    @team.latlon = User.find(params[:team][:location_user_id]).latlon

    respond_to do |format|
      if @team.save

        # adicionar os v�rios membros da equipa, colocar aqui um FOR!
        # todos os elementos sao adicionados como nao sendo lider
        params[:team][:users].each do |u_id|
          puts "LOOOOOOOOOOOOOOOL"
          puts u_id
          puts params[:team][:id]

          puts "LEADER LEADER LEADER LEADER"
          puts params[:team][:is_leader]

          puts "RESPONSAVEL LOCALIZAÇÃO"
          puts params[:team][:location_user_id]

          # é o lider, adiciona-se com o parametro a true
          if u_id == params[:team][:is_leader]
            team_member = TeamMember.new(:user_id => u_id.to_i, :team_id => @team.id, :is_leader => true)
          else
            team_member = TeamMember.new(:user_id => u_id.to_i, :team_id => @team.id, :is_leader => false)
          end

          team_member.save
        end

        format.html { redirect_to @team, notice: 'create_success' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|

      # verificamos se o utilizador responsavel pela posição foi alterado
      # se sim, atualizamos a posição atual da equipa
      if @team.location_user_id != params[:team][:location_user_id].to_i
        @team.location_user_id = params[:team][:location_user_id].to_i
        @team.latlon = User.find(params[:team][:location_user_id].to_i).latlon
        params[:team].delete(:location_user_id)
      end

      if @team.update(team_params)


        # come�amos por remover todas as entradas da tabela para esta equipa
        TeamMember.delete_all(["team_id = ?", @team.id.to_s])

        # por fim, adicionamos novamente os membros da equipa, bem como qual o capit�o
        params[:team][:users].each do |u_id|
          if u_id == params[:team][:is_leader]
            team_member = TeamMember.new(:user_id => u_id, :team_id => @team.id, :is_leader => true)
          else
            team_member = TeamMember.new(:user_id => u_id, :team_id => @team.id, :is_leader => false)
          end
          team_member.save
        end

        format.html { redirect_to @team, notice: 'edit_success' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_user_to_team
    puts "**********************************************"
    puts "ADD_USER_TO_TEAM HEHEHEHEHEHEHE"
    puts "**********************************************"

    t_member = TeamMember.new(:user_id => params[:user_id].to_i, :team_id => params[:team_id].to_i, :is_leader => false)
    if t_member.save
      @recently_added_user = User.where(id: params[:user_id]).first

      puts @recently_added_user.inspect

      # o utilizador que acabamos de introduzir nao é nem o lider nem o responsavel pela posição
      render partial: 'list_entry', locals: {user: @recently_added_user, is_leader: false, in_charge_of_location: false}
    else # em caso de erro enviar codigo de erro para o jquery
      puts t_member.errors.inspect
      render :nothing => true, :status => 500, :content_type => 'text/html'
    end
  end

  def remove_user_from_team
    puts "**********************************************"
    puts "REMOVE_USER_FROM_TEAM HEHEHEHEHEHEHE"
    puts "**********************************************"

    t_member = TeamMember.where(:user_id => params[:user_id], :team_id => params[:team_id]).first
    if TeamMember.destroy(t_member.id)
      render :nothing => true, :status => 200, :content_type => 'text/html'
    else # em caso de erro enviar codigo de erro para o jquery
      render :nothing => true, :status => 500, :content_type => 'text/html'
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    if params[:name]
      puts "INTRODUZIDO NOME PARA A EQUIPA!!!!"
      @team = Team.where(name: params[:name]).first
    else
      puts "DESTA VEZ RECEBI UM IDENTIFICADOR!!!!"
      # count = Team.count
      exists = Team.exists?(params[:id].to_i)
      puts exists
      if exists
        @team = Team.find(params[:id])
      end
    end
  end

  # def set_users_without_team
  #   members_unique_ids = TeamMember.uniq(:user_id).select(:user_id)
  #   @users_without_team = User.where.not(id: members_unique_ids)
  # end

  def set_all_users
    @all_users = User.all
  end

  def set_users_not_in_this_team
    @all_users_arr = [["Administrador", []], ["Gestor", []], ["Operacional", []]]

    members_ids = TeamMember.where(team_id: @team.id).select(:user_id)
    users_not_in_this_team = User.where.not(id: members_ids).order(first_name: :asc, last_name: :asc)

    # os ciclos de baixo colocam os utilizadores que ainda nao estao na equipa dentro dum array
    # para dps ser apresentado com grupos por perfil
    users_not_in_this_team.where(profile: User::ADMINISTRADOR).each do |user|
      elem = []
      elem.push(user.full_name)
      elem.push(user.id)
      @all_users_arr[0][1].push(elem)
    end

    users_not_in_this_team.where(profile: User::GESTOR).each do |user|
      elem = []
      elem.push(user.full_name)
      elem.push(user.id)
      @all_users_arr[1][1].push(elem)
    end

    users_not_in_this_team.where(profile: User::OPERACIONAL).each do |user|
      elem = []
      elem.push(user.full_name)
      elem.push(user.id)
      @all_users_arr[2][1].push(elem)
    end

    puts @all_users_arr.inspect
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :latlon_highlight, :location_user_id, :is_leader, users: [:id])
  end
end
