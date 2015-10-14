json.array!(@teams) do |team|
  json.extract! team, :id, :name, :latlon
  json.url team_url(team, format: :json)
end
