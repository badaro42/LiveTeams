class GeoEntitiesController < ApplicationController
  before_action :set_geo_entity, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!


  def geo_entities_to_json
    require 'rgeo'
    require 'rgeo-geojson'

    features = GeoEntity.all # todas as entidades presentes no sistema
    factory = RGeo::GeoJSON::EntityFactory.instance # cria a fabrica de entidades

    # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
    # transformadas em json
    mapped_feats = factory.map_feature_collection(features) {
        |f| factory.feature(f.latlon, nil, {f_id: f.id, name: f.name, username: User.find(f.user_id).full_name,
                                            user_id: f.user_id, description: f.description, radius: f.radius,
                                            created_at: f.created_at, entity_type: f.entity_type})
    }

    # dps do mapeamento, s�o enviadas para a fabrica que trata da transforma��o para json para serem apresentadas no mapa
    features_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_feats)
    render json: features_to_json
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
    @geo_entity.name = params[:geo_entity][:name]
    @geo_entity.entity_type = params[:geo_entity][:entity_type]
    @geo_entity.description = params[:geo_entity][:description]
    @geo_entity.latlon = params[:geo_entity][:latlon]
    @geo_entity.user_id = current_user.id
    @geo_entity.radius = params[:geo_entity][:radius]
    @geo_entity.team_ids = params[:geo_entity][:team_ids]

    puts @geo_entity.inspect

    respond_to do |format|
      if @geo_entity.save
        geo_factory = RGeo::GeoJSON::EntityFactory.instance
        feature = geo_factory.feature(@geo_entity.latlon, nil, {f_id: @geo_entity.id, name: @geo_entity.name,
                                                                username: User.find(@geo_entity.user_id).full_name,
                                                                user_id: @geo_entity.user_id,
                                                                description: @geo_entity.description,
                                                                radius: @geo_entity.radius,
                                                                created_at: @geo_entity.created_at,
                                                                entity_type: @geo_entity.entity_type})
        feature_to_json = RGeo::GeoJSON.encode feature

        format.html { redirect_to @geo_entity, notice: 'Geo entity was successfully created.' }
        # format.json { render :show, status: :created, location: @geo_entity }
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
    params.require(:geo_entity).permit(:name, :latlon, :user_id, :description, :entity_type, :radius, :team_ids)
  end
end
