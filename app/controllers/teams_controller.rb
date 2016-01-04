class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :set_team_geo_entities, only: [:show, :destroy]
  before_filter :authenticate_user!
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
  def index
    @teams = Team.all.order(id: :asc)
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
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
    @users_in_team = @team.users

    set_users_for_multiple_select("new")
  end

  # GET /teams/1/edit
  def edit
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
          if u_id.to_i > 0
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

      @team.updated_at = Time.now

      if @team.update(team_params)
        # começamos por remover todas as entradas da tabela para esta equipa
        TeamMember.delete_all(["team_id = ?", @team.id.to_i])

        # por fim, adicionamos novamente os membros da equipa, bem como qual o capit�o
        params[:team][:users].each do |u_id|
          new_id = u_id.to_i
          leader_id = params[:team][:is_leader].to_i
          puts "==============================="
          puts "new_id: "
          puts new_id
          puts "leader id: "
          puts leader_id
          puts "é a mesma merda?:"
          puts (new_id === leader_id)
          puts "==============================="
          if new_id === leader_id
            team_member = TeamMember.new(:user_id => new_id, :team_id => @team.id, :is_leader => true)
          else
            team_member = TeamMember.new(:user_id => new_id, :team_id => @team.id, :is_leader => false)
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
    team_id = @team.id.to_s

    # elimina a equipa. se o delete for bem sucedido, removemos os ids da equipa das geo-entidades
    @team.destroy
    if @team.destroyed?
      @team_geo_entities.each do |geo_entity|
        geo_entity.team_ids.delete(team_id)
      end
    end

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
