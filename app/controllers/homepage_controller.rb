class HomepageController < ApplicationController
  def index
    @all_users = User.all
    @all_teams = Team.all
  end
end
