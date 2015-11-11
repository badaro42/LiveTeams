class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  # before_action :set_flash
  layout "listings"

  def update_location
    current_user.latlon = params[:latlon]
    current_user.save

    # atualizar a posição de todas as equipas que tenham este user como responsavel por atualizar a localização
    teams = Team.where(location_user_id: params[:user_id].to_i)
    teams.each do |team|
      team.latlon = params[:latlon]
      team.save
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
