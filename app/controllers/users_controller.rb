class UsersController < ApplicationController
  before_action :set_team, only: [:show, :edit]
  layout "listings"

  def index
    @users = User.all
  end

  def show
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
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @user = User.find(params[:id])
  end
end
