class UsersController < ApplicationController
  # before_action :set_user, only: [:show]
  before_action :set_user, only: [:show, :edit, :update]
  before_filter :authenticate_user!
  layout "listings"



  def get_geo_entities
    require 'rgeo'
    require 'rgeo-geojson'

    features = GeoEntity.all
    # puts features

    # cria a fabrica de entidades
    factory = RGeo::GeoJSON::EntityFactory.instance
    # puts factory

    # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
    # transformadas em json
    mapped_feats = factory.map_feature_collection(features) {
        |f| factory.feature(f.latlon, nil, {f_id: f.id, name: f.name, user_name: User.find(f.user_id).full_name,
                                            user_id: f.user_id, description: f.description, radius: f.radius,
                                            created_at: f.created_at, entity_type: f.entity_type})
    }

    # puts mapped_feats

    # dps do mapeamento, s�o enviadas para a fabrica que trata da transforma��o para json para serem apresentadas no mapa
    features_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_feats)

    # puts teste
    render json: features_to_json
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

  def index
    @users = User.all
  end

  def show
    # variavel para fornecer o id no jquery
    gon.user_id = @user.id
    gon.curr_user_pos = @user.latlon

    @user_teams = @user.teams
    @user_team_members = @user.team_members

    @user_entities = @user.geo_entities

    puts @user_teams.count
    puts @user_teams.inspect
    puts "-----------------"
    puts @user_team_members.count
    puts @user_team_members.inspect
    puts "-----------------"
    puts @user_entities.count
    puts @user_entities.inspect
  end

  def edit
    if params[:id] == nil
      @user = User.find(current_user.id)
    else
      @user = User.find(params[:id])
    end
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update(account_update_params)
        format.html { redirect_to @user, notice: 'edit_success' }
        format.json { render :show, status: :ok, location: @user }
      else
        puts @user.errors.inspect
        format.html { render :edit, notice: 'edit_error' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar,
                                 :profile, :phone_number)
  end
end
