class TeamMembersController < ApplicationController
  before_action :set_team_member, only: [:show, :edit, :update, :destroy]

  # GET /team_members
  # GET /team_members.json
  def index
    # @team_members = TeamMember.al
    redirect_to root_path
  end

  # GET /team_members/1
  # GET /team_members/1.json
  def show
    redirect_to root_path
  end

  # GET /team_members/new
  def new
    # @team_member = TeamMember.new
    redirect_to root_path
  end

  # GET /team_members/1/edit
  def edit
    redirect_to root_path
  end

  # POST /team_members
  # POST /team_members.json
  def create
    custom_authorize!(Permission::CLASS_TEAM_MEMBER, Permission::ACTION_CREATE)

    @team_member = TeamMember.new(team_member_params)
    if @team_member.save
      @recently_added_user = User.find(params[:team_member][:user_id].to_i)

      puts @recently_added_user.inspect

      # o utilizador que acabamos de introduzir nao é nem o lider nem o responsavel pela posição
      render partial: 'teams/list_entry', locals: {user: @recently_added_user, is_leader: false,
                                                   in_charge_of_location: false}
    else # em caso de erro enviar codigo de erro para o jquery
      render nothing: true, status: :internal_server_error, content_type: 'text/html'
    end

  rescue AccessDenied
    render nothing: true, status: :forbidden
  end

  # PATCH/PUT /team_members/1
  # PATCH/PUT /team_members/1.json
  def update
    redirect_to teams_path

    # authorize! :update, TeamMember
    # respond_to do |format|
    #   if @team_member.update(team_member_params)
    #     format.html { redirect_to @team_member, notice: 'Team member was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @team_member }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @team_member.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /team_members/1
  # DELETE /team_members/1.json
  def destroy
    custom_authorize!(Permission::CLASS_TEAM_MEMBER, Permission::ACTION_DESTROY)

    if @team_member.destroy
      render nothing: true, status: :ok, content_type: 'text/html'
    else # em caso de erro enviar codigo de erro para o jquery
      render nothing: true, status: :internal_server_error, content_type: 'text/html'
    end

  rescue AccessDenied
    render nothing: true, status: :forbidden
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team_member
    @team_member = TeamMember.where(:user_id => params[:user_id], :team_id => params[:team_id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_member_params
    params.require(:team_member).permit(:team_id, :user_id, :is_leader)
  end
end