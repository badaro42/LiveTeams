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
                              leader_name: ((TeamMember.where(team_id: ent.id, is_leader: true) == []) ? "" :
                                  User.find(TeamMember.where(team_id: ent.id, is_leader: true).first.user_id).full_name),
                              leader_id: ((TeamMember.where(team_id: ent.id, is_leader: true) == []) ? 0 :
                                  User.find(TeamMember.where(team_id: ent.id, is_leader: true).first.user_id).id),
                              highlight_coords: f.latlon_highlight
                             }
      )
      teams_to_json = RGeo::GeoJSON.encode team
    else
      mapped_teams = factory.map_feature_collection(teams) {
          |f| factory.feature(User.find(f.location_user_id).latlon, nil,
                              {name: f.name, f_id: f.id, location_user_id: f.location_user_id,
                               created_at: f.created_at, updated_at: f.updated_at,
                               location_user_name: User.find(f.location_user_id).full_name,
                               leader_name: ((TeamMember.where(team_id: f.id, is_leader: true) == []) ? "" :
                                   User.find(TeamMember.where(team_id: f.id, is_leader: true).first.user_id).full_name),
                               leader_id: ((TeamMember.where(team_id: f.id, is_leader: true) == []) ? 0 :
                                   User.find(TeamMember.where(team_id: f.id, is_leader: true).first.user_id).id),
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

    if geo_entities.size == 1
      f = geo_entities.first
      feature = factory.feature(f.latlon, nil,
                                {f_id: f.id, name: f.name, username: User.find(f.user_id).full_name,
                                                user_id: f.user_id, description: f.description, radius: f.radius,
                                                created_at: f.created_at, entity_type: f.entity_type
                                }
      )
      geo_entities_to_json = RGeo::GeoJSON.encode feature
    else
      # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
      # transformadas em json
      mapped_feats = factory.map_feature_collection(geo_entities) {
          |f| factory.feature(f.latlon, nil,
                              {f_id: f.id, name: f.name, username: User.find(f.user_id).full_name,
                               user_id: f.user_id, description: f.description, radius: f.radius,
                               created_at: f.created_at, entity_type: f.entity_type
                              }
        )
      }
      geo_entities_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_feats)
    end

    geo_entities_to_json
  end
end