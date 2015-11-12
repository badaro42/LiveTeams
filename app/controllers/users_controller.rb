class UsersController < ApplicationController
  before_action :set_user, only: [:show]
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
    if distance > 20
      current_user.latlon = new_point
      current_user.save

      gon.update_successful = true

      # atualizar a posição de todas as equipas que tenham este user como responsavel por atualizar a localização
      teams = Team.where(location_user_id: params[:user_id].to_i)
      teams.each do |team|
        team.latlon = new_point
        team.save
      end
    end

    # puts a.errors.messages

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def index
    @users = User.all
  end

  def show
    # variavel para fornecer o id no jquery
    gon.user_id = @user.id

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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # def set_flash
  #   flash[:error] = ""
  # end
end
