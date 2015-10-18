class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  layout "listings"

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
    @all_users = User.all
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save

        puts "EQUIPA DO CRL1!!!!!!!!!!!!"
        puts @team.id

        # adicionar os vários membros da equipa, colocar aqui um FOR!
        # todos os elementos sao adicionados como nao sendo lider
        params[:team][:users].each do |u_id|
          puts "LOOOOOOOOOOOOOOOL"
          puts u_id
          puts params[:team][:id]
          puts "LOOOOOOOOOOOOOOOL"

          @team_member = TeamMember.new(:user_id => u_id, :team_id => @team.id, :is_leader => false)
          @team_member.save

          # dps dos elementos todos inseridos, procura-se aquele que tem um ID igual ao passado no parametro de lider
          # esse registo é entao atualizado e passa a ser o lider da equipa
          #@team_member = TeamMember.all.find_by(:user_id => , :team_id => )
          #@team_member.is_leader = true
          #@team_member.save
        end

        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :latlon, users: [:id])
  end
end
