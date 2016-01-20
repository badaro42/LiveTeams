class UserRoleController < ApplicationController
  layout "listings"

  def index
    @users_filter = initialize_filterrific(
        User,
        params[:filterrific],
        select_options: {
            with_role_name: Role.options_for_select,
            with_team: Team.options_for_filter_by_team
        }
        # persistence_id: false
    ) or return

    @users = User.filterrific_find(@users_filter)

    respond_to do |format|
      format.html
      format.js
    end

  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def create
  end

  def destroy
  end
end
