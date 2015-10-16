class UsersController < ApplicationController
  before_action :set_team, only: [:show, :edit]
  layout "listings"

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @user = User.find(params[:id])
  end
end
