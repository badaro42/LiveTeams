class GeoEntitiesController < ApplicationController
  before_action :set_geo_entity, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  require 'encode_to_json'

  def geo_entities_to_json
    geo_entities_to_json = EncodeToJson::encode_geo_entities_to_json(GeoEntity.all)
    render json: geo_entities_to_json
  end

  # GET /geo_entities
  # GET /geo_entities.json
  def index
    @geo_entities = GeoEntity.all
  end

  # GET /geo_entities/1
  # GET /geo_entities/1.json
  def show
  end

  # GET /geo_entities/new
  def new
    @geo_entity = GeoEntity.new
  end

  # GET /geo_entities/1/edit
  def edit
  end

  # POST /geo_entities
  # POST /geo_entities.json
  def create
    @geo_entity = GeoEntity.new(geo_entity_params)
    @geo_entity.user_id = current_user.id

    puts @geo_entity.inspect

    respond_to do |format|
      if @geo_entity.save
        feature_to_json = EncodeToJson::encode_geo_entities_to_json(@geo_entity)

        format.html { redirect_to @geo_entity, notice: 'Geo entity was successfully created.' }
        format.json { render json: feature_to_json }
      else
        format.html { render :new }
        format.json { render json: @geo_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /geo_entities/1
  # PATCH/PUT /geo_entities/1.json
  def update
    respond_to do |format|
      if @geo_entity.update(geo_entity_params)
        format.html { redirect_to @geo_entity, notice: 'Geo entity was successfully updated.' }
        format.json { render :show, status: :ok, location: @geo_entity }
      else
        format.html { render :edit }
        format.json { render json: @geo_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /geo_entities/1
  # DELETE /geo_entities/1.json
  def destroy
    @geo_entity.destroy
    respond_to do |format|
      format.html { redirect_to geo_entities_url, notice: 'Geo entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_geo_entity
    @geo_entity = GeoEntity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def geo_entity_params
    params.require(:geo_entity).permit(:name, :latlon, :user_id, :description, :entity_type, :radius, {:team_ids => []})
  end
end
