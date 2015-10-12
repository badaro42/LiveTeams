class UsersController < ApplicationController

  #Corre a fun��o set_user antes das chamadas a show, edit...
  #before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index

    # if user_signed_in?
    #   if current_user.id == 1
    #     @users = User.all
    #   else
    #     flash[:error] = "N�o tens permiss�es para realizar tal ac��o!"
    #     redirect_to root_url
    #   end
    # elsif params[:type] == 'admin'
    #   @users = User.all
    # else
    #   flash[:error] = "N�o tens permiss�es para realizar tal ac��o!"
    #   redirect_to root_url
    # end

  end

  # GET /users/1
  # GET /users/1.json
  def show

    # if @user.nil?
    #   flash[:error] = "O utilizador que procuras n�o existe!"
    #   redirect_to root_url
    # end

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    # if current_user.nil?
    #   flash[:error] = "N�o tens permiss�es para realizar essa ac��o!"
    #   redirect_to root_url
    # else
    #   if params[:id].to_i == current_user.id
    #     redirect_to edit_user_registration_path
    #   elsif current_user.id == 1
    #     #� o admin, ele pode editar!
    #   else
    #     flash[:error] = "N�o tens permiss�es para editar esse utilizador!"
    #     redirect_to root_url
    #   end
    # end
  end

  # POST /users
  # POST /users.json
  def create

    # puts "LOOOL"
    #
    # @user = User.new(sign_up_params)
    # @user.avatar = params[:user][:avatar]
    # @user.save
    # respond_with @user



    # puts "LOOOOOOOOOOOOL"
    #
    # @user = User.new(user_params)
    # @user.avatar_url = '/images/placeholder.png'
    #
    # respond_to do |format|
    #   if @user.save
    #     format.html { redirect_to root, notice: 'Utilizador criado com sucesso.' }
    #     format.json { render :show, status: :created, location: @user }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root, notice: 'Utilizador atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root, notice: 'Utilizador removido com sucesso.' }
      format.json { head :no_content }
    end
  end






  private
  # Use callbacks to share common setup or constraints between actions.
  # def set_user
  #   if params[:name]
  #     @user = User.where(name: params[:name]).first
  #   else
  #     count = User.count
  #     exists = User.exists?(params[:id].to_i)
  #     if (params[:id].to_i <= count) and exists
  #       @user = User.find(params[:id])
  #     end
  #   end
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar)
  end
end