class HomepageController < ApplicationController
  def index
    @most_active_users = User.all.order(sign_in_count: :desc).limit(15)
    @all_teams = Team.all
  end
end
