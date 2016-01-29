require 'rgeo'
require 'rgeo-geojson'

module EncodeToJson
  def self.encode_teams_to_json(teams)
    factory = RGeo::GeoJSON::EntityFactory.instance
    teams_to_json = nil

    if teams.size == 1
      ent = teams.first
      team = factory.feature(User.find(ent.location_user_id).latlon, nil,
                             {name: ent.name, f_id: ent.id, location_user_id: ent.location_user_id,
                              created_at: ent.created_at, updated_at: ent.updated_at,
                              location_user_name: User.find(ent.location_user_id).full_name,
                              leader_id: ent.leader_id, leader_name: User.find(ent.leader_id).full_name,
                              highlight_coords: ent.latlon_highlight
                             }
      )
      teams_to_json = RGeo::GeoJSON.encode team
    else
      mapped_teams = factory.map_feature_collection(teams) {
          |f| factory.feature(User.find(f.location_user_id).latlon, nil,
                              {name: f.name, f_id: f.id, location_user_id: f.location_user_id,
                               created_at: f.created_at, updated_at: f.updated_at,
                               location_user_name: User.find(f.location_user_id).full_name,
                               leader_id: f.leader_id, leader_name: User.find(f.leader_id).full_name,
                               highlight_coords: f.latlon_highlight
                              }
        )
      }
      # dps do mapeamento, s�o enviadas para a fabrica que trata da transforma��o
      # para json para serem apresentadas no mapa
      teams_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_teams)
    end

    teams_to_json
  end

  def self.encode_geo_entities_to_json(geo_entities)
    factory = RGeo::GeoJSON::EntityFactory.instance
    geo_entities_to_json = nil

    size = 0
    # apenas uma entidade, size a 1
    if geo_entities.is_a? GeoEntity
      size = 1
    end

    if size == 1
      feature = factory.feature(geo_entities.latlon, nil,
                                {f_id: geo_entities.id, name: geo_entities.name,
                                 username: geo_entities.user.full_name,
                                 user_id: geo_entities.user_id, description: geo_entities.description,
                                 radius: geo_entities.radius, created_at: geo_entities.created_at,
                                 updated_at: geo_entities.updated_at, entity_type: geo_entities.entity_type,
                                 category_id: geo_entities.category_id, category_name: geo_entities.category.name
                                }
      )
      geo_entities_to_json = RGeo::GeoJSON.encode feature
    else
      # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
      # transformadas em json
      mapped_feats = factory.map_feature_collection(geo_entities) {
          |f| factory.feature(f.latlon, nil,
                              {f_id: f.id, name: f.name, username: f.user.full_name,
                               user_id: f.user_id, description: f.description, radius: f.radius,
                               updated_at: f.updated_at, created_at: f.created_at, entity_type: f.entity_type,
                               category_id: f.category_id, category_name: f.category.name
                              }
        )
      }
      geo_entities_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_feats)
    end

    geo_entities_to_json
  end
end