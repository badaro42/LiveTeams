require 'rgeo'
require 'rgeo-geojson'

module EncodeToJson
  def self.encode_teams_to_json(obj)
    factory = RGeo::GeoJSON::EntityFactory.instance
    teams_to_json = nil

    if obj.length == 1
      team = obj.first
      feature = factory.feature(User.find(team.location_user_id).latlon, nil,
                                {
                                    name: team.name, f_id: team.id, location_user_id: team.location_user_id,
                                    created_at: team.created_at, updated_at: team.updated_at,
                                    location_user_name: User.find(team.location_user_id).full_name,
                                    leader_id: team.leader_id, leader_name: User.find(team.leader_id).full_name,
                                    highlight_coords: team.latlon_highlight
                                }
      )
      teams_to_json = RGeo::GeoJSON.encode feature
    else
      mapped_teams = factory.map_feature_collection(obj) {
          |f| factory.feature(User.find(f.location_user_id).latlon, nil,
                              {
                                  name: f.name, f_id: f.id, location_user_id: f.location_user_id,
                                  created_at: f.created_at, updated_at: f.updated_at,
                                  location_user_name: User.find(f.location_user_id).full_name,
                                  leader_id: f.leader_id, leader_name: User.find(f.leader_id).full_name,
                                  highlight_coords: f.latlon_highlight
                              }
        )
      }
      teams_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_teams)
    end

    teams_to_json
  end

  def self.encode_geo_entities_to_json(obj)
    factory = RGeo::GeoJSON::EntityFactory.instance
    geo_entities_to_json = nil

    if obj.length == 1
      feature = factory.feature(obj.latlon, nil,
                                {
                                    f_id: obj.id, name: obj.name, username: obj.user.full_name, user_id: obj.user_id,
                                    description: obj.description, radius: obj.radius, created_at: obj.created_at,
                                    updated_at: obj.updated_at, entity_type: obj.entity_type,
                                    category_id: obj.category_id, category_name: obj.category.name
                                }
      )
      geo_entities_to_json = RGeo::GeoJSON.encode feature
    else
      mapped_feats = factory.map_feature_collection(obj) {
          |f| factory.feature(f.latlon, nil,
                              {
                                  f_id: f.id, name: f.name, username: f.user.full_name, user_id: f.user_id,
                                  description: f.description, radius: f.radius, updated_at: f.updated_at,
                                  created_at: f.created_at, entity_type: f.entity_type,
                                  category_id: f.category_id, category_name: f.category.name
                              }
        )
      }
      geo_entities_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_feats)
    end

    geo_entities_to_json
  end

  def self.encode_users_to_json(obj)
    factory = RGeo::GeoJSON::EntityFactory.instance
    users_to_json = nil

    if obj.length == 1
      feature = factory.feature(obj.latlon, nil,
                                {
                                    user_id: obj.id, full_name: obj.full_name, email: obj.email,
                                    phone_number: obj.phone_number, profile: obj.profile
                                }
      )
      users_to_json = RGeo::GeoJSON.encode feature
    else
      mapped_feats = factory.map_feature_collection(obj) {
          |f| factory.feature(f.latlon, nil,
                              {
                                  user_id: f.id, full_name: f.full_name, email: f.email,
                                  phone_number: f.phone_number, profile: f.profile
                              }
        )
      }
      users_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_feats)
    end

    users_to_json
  end
end