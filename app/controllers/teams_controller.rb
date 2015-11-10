class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :set_all_users, only: [:new, :edit]

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
        |f| factory.feature(f.users.where(id: f.location_user_id).first.latlon, nil, {name: f.name, f_id: f.id}) }

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
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team.inspect

    if @team.nil?
      flash[:error] = "A equipa que procura nao existe!"
      redirect_to teams_url
    else
      puts "TAMANHO DAS VERSOES DESTA EQUIPA!!!!"
      puts @team.versions.size
      puts @team.versions.inspect
      puts @team.versions.first.reify.inspect
      puts @team.versions.last.reify.inspect

      gon.current_latlon = @team.latlon
      gon.team_versions = []
      @team.versions.each do |version|
        gon.team_versions.push(version.reify)
      end

      team_leader_id = @team.team_members.where(is_leader: true).first
      puts team_leader_id.inspect
      @team_leader = @team.users.where(id: team_leader_id.user_id).first
      puts @team_leader.inspect

      @location_user = User.find(@team.location_user_id)
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

        # format.html { redirect_to action: "show", id: @team.id, status: "success" }
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
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

        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
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
    # @team = Team.find(params[:id])
  end

  def set_all_users
    @all_users = User.all.order(id: :asc)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :latlon_highlight, :location_user_id, :is_leader, users: [:id])
  end
end
