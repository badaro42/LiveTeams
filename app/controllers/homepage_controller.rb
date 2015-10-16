class HomepageController < ApplicationController
  def index
    @most_active_users = User.all.order(sign_in_count: :desc).limit(15)
    @recently_changed_teams = Team.all.order(updated_at: :desc).limit(15)
  end
end
