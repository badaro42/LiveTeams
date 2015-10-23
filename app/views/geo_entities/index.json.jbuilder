json.array!(@geo_entities) do |geo_entity|
  json.extract! geo_entity, :id, :name, :latlon, :user_id, :description
  json.url geo_entity_url(geo_entity, format: :json)
end
