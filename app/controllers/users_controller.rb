class UsersController < ApplicationController
  # before_action :set_user, only: [:show]
  before_action :set_user, only: [:show, :edit, :update]
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
    # if distance > 20
    current_user.latlon = new_point
    current_user.save

    teams_in_need_of_update = []

    # atualizar a posição de todas as equipas que tenham este user como responsavel por atualizar a localização
    teams = Team.where(location_user_id: params[:user_id].to_i)
    teams.each do |team|
      teams_in_need_of_update.push(team.id)

      team.latlon = new_point
      team.save
    end
    # end

    # todas as equipas cujo utilizador é responsavel pela posição sao introduzidas neste array
    gon.teams_user_update_position = teams_in_need_of_update

    puts "IDS DAS EQUIPAS QUE TÊM COMO RESPONSAVEL ESTE GAJO:"
    puts gon.teams_user_update_position.inspect

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

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update(account_update_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        puts @user.errors.inspect
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar,
                                 :profile, :phone_number)
  end
end
