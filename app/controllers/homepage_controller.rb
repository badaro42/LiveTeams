class HomepageController < ApplicationController

  def index
    @most_active_users = User.all.order(sign_in_count: :desc).limit(15)
    @recently_changed_teams = Team.all.order(updated_at: :desc).limit(15)
  end

  def get_geo_stuff
    require 'rgeo'
    require 'rgeo-geojson'

    features = GeoStuff.all

    # cria a fabrica de entidades
    factory = RGeo::GeoJSON::EntityFactory.instance

    # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
    # transformadas em json
    mapped_feats = factory.map_feature_collection(features){ |f| factory.feature(f.coords, nil, { desc: f.name})}

    # dps do mapeamento, são enviadas para a fabrica que trata da transformação para json para serem apresentadas no mapa
    features_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_feats)

    # puts teste
    render json: features_to_json
  end
end
