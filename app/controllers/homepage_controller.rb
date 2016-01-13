class HomepageController < ApplicationController
  include ActionController::Live
  before_filter :authenticate_user!
  require 'encode_to_json'

  def geocode_location
    require 'geocoder'

    result = Geocoder.search(params[:location])
    render json: result.to_json
  end

  def index
    @most_active_users = User.all.order(sign_in_count: :desc).limit(15)
    @recently_changed_teams = Team.all.order(updated_at: :desc).limit(15)

    gon.push({
                 user_id: current_user.id,
                 current_lat: current_user.latlon.lat,
                 current_lon: current_user.latlon.lon,
                 user_profile: current_user.profile
             })
  end

  def entity_updates
    require 'rgeo'
    require 'rgeo-geojson'

    puts "SERA QUE HA NOVA CENA!!!!????"
    ActiveRecord::Base.include_root_in_json = true
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 20000, event: 'event_update')

    # devolve os utilizadores criados ou atualizados nos ultimos 22 segundos
    geo_entities_to_parse = GeoEntity.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
                                            21.seconds.ago, Time.now, 21.seconds.ago, Time.now)
    # devolve as equipas criadas ou atualizadas nos ultimos 22 segundos
    teams_to_parse = Team.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
                                21.seconds.ago, Time.now, 21.seconds.ago, Time.now)

    # devolve as equipas e geo-entidade eliminadas nos ultimos 22 segundos
    recently_deleted_team_array = []
    recently_deleted_geo_entity_array = []
    recently_deleted_team_versions = PaperTrail::Version.where('event = ? and created_at > ? and item_type = ?',
                                                               'destroy', 21.seconds.ago, 'Team')
    recently_deleted_geo_entity_versions = PaperTrail::Version.where('event = ? and created_at > ? and item_type = ?',
                                                                     'destroy', 21.seconds.ago, 'GeoEntity')

    # pomos a data de atualização a nil para no javascript sabermos que é para remover
    recently_deleted_team_versions.each do |team|
      temp = team.reify
      temp.updated_at = nil
      recently_deleted_team_array.push(temp)
    end
    recently_deleted_geo_entity_versions.each do |geo_entity|
      temp = geo_entity.reify
      temp.updated_at = nil
      recently_deleted_geo_entity_array.push(temp)
    end

    # uniao entre os 2 conjuntos
    teams_to_parse = teams_to_parse | recently_deleted_team_array
    geo_entities_to_parse = geo_entities_to_parse | recently_deleted_geo_entity_array

    geo_entities_to_json = EncodeToJson::encode_geo_entities_to_json(geo_entities_to_parse)
    teams_to_json = EncodeToJson::encode_teams_to_json(teams_to_parse)

    begin
      if geo_entities_to_parse.size > 0 && teams_to_parse.size > 0
        # equipas e entidades novas para enviar
        puts "ENTIDADE NOVA E EQUIPA NOVA NOS ULTIMOS 20 SEGUNDOS"
        sse.write(geo_entities_to_json,
                  event: 'entity_updates', retry: 20000)
        sse.write(teams_to_json,
                  event: 'team_updates', retry: 20000)
      elsif geo_entities_to_parse.size > 0
        # apenas entidades novas para enviar
        puts "APENAS ENTIDADE NOVA NOS ULTIMOS 20 SEGUNDOS"
        sse.write(geo_entities_to_json,
                  event: 'entity_updates', retry: 20000)
      elsif teams_to_parse.size > 0
        # apenas equipas novas para enviar
        puts "APENAS EQUIPA NOVA NOS ULTIMOS 20 SEGUNDOS"
        sse.write(teams_to_json,
                  event: 'team_updates', retry: 20000)
      else
        puts "NAO ENTROU NA CENA Da cena que da para cena"
        render :nothing => true, :status => 200, :content_type => 'text/html'
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      puts "CLOSE cena cena"
      sse.close
    end
  end

end
