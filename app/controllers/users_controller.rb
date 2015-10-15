class UsersController < ApplicationController
  layout "listings"

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end
end
