class UserRoleController < ApplicationController
  before_filter :authenticate_user!
  layout "listings"

  def index
    @users_create_filter = initialize_filterrific(
        User,
        params[:filterrific],
        select_options: {
            with_role_name: Role.options_for_select,
            with_team: Team.options_for_filter_by_team
        },
        persistence_id: false
    ) or return

    @users_destroy_filter = initialize_filterrific(
        User,
        params[:filterrific],
        persistence_id: false
    ) or return

    @users_create = User.filterrific_find(@users_create_filter)
    @users_destroy = User.filterrific_find(@users_destroy_filter)

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
    puts "************************"
    puts " USER_ROLE CREATE ROLES"
    puts "************************"

    records_to_save = []
    expiration_date = params[:user_role][:expiration_date].to_f
    params[:user_role][:role_ids].each do |role_id|
      params[:user_role][:user_ids].each do |user_id|
        user_role = UserRole.find_or_initialize_by(role_id: role_id.to_i, user_id: user_id.to_i)
        user_role.expiration_date = expiration_date.to_f.hours.since
        records_to_save.push(user_role)
      end
    end

    UserRole.transaction do
      records_to_save.each(&:save)
    end

    render nothing: true, status: :ok

  rescue Exception
    render nothing: true, status: :internal_server_error

  end

  def destroy
    puts "********************************"
    puts " USER_ROLE DESTROY DESTROY ROLES"
    puts "********************************"

    # TODO: DESATIVEI ESTA CENA APENAS PARA TESTES! ATIVAR MAIS TARDE!!
    UserRole.destroy(UserRole.where("role_id = ? and user_id = ?", params[:user_role][:role_id],
                                    params[:user_role][:user_id]).first)

    render nothing: true, status: :ok

  rescue ActiveRecord::RecordNotFound
    render nothing: true, status: :internal_server_error
  end
end
