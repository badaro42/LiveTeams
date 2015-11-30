class HomepageController < ApplicationController
  include ActionController::Live
  before_filter :authenticate_user!

  def index
    @most_active_users = User.all.order(sign_in_count: :desc).limit(15)
    @recently_changed_teams = Team.all.order(updated_at: :desc).limit(15)

    gon.user_id = current_user.id
  end


  def entity_updates
    require 'rgeo'
    require 'rgeo-geojson'

    ActiveRecord::Base.include_root_in_json = true
    response.headers['Content-Type'] = 'text/event-stream'

    # cria a fabrica de entidades
    geo_factory = RGeo::GeoJSON::EntityFactory.instance
    team_factory = RGeo::GeoJSON::EntityFactory.instance
    features_to_json = nil
    teams_to_json = nil

    puts "SERA QUE HA NOVA CENA!!!!????"
    sse = SSE.new(response.stream, retry: 20000, event: 'event_update')

    # devolve os utilizadores criados ou atualizados nos ultimos 20 segundos
    new_or_updated_geo_entity = GeoEntity.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
                                                25.seconds.ago, Time.now, 25.seconds.ago, Time.now)
    # devolve as equipas criadas ou atualizadas nos ultimos 20 segundos
    new_or_updated_teams = Team.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
                                      25.seconds.ago, Time.now, 25.seconds.ago, Time.now)

    # codifica as entidades geograficas
    if new_or_updated_geo_entity.size == 1
      ent = new_or_updated_geo_entity.first
      feature = geo_factory.feature(ent.latlon, nil, {f_id: ent.id, name: ent.name, username: User.find(ent.user_id).full_name,
                                                      description: ent.description, radius: ent.radius,
                                                      created_at: ent.created_at, entity_type: ent.entity_type})
      features_to_json = RGeo::GeoJSON.encode feature
    else
      # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
      # transformadas em json
      mapped_feats = geo_factory.map_feature_collection(new_or_updated_geo_entity) {
          |f| geo_factory.feature(f.latlon, nil, {f_id: f.id, name: f.name, username: User.find(f.user_id).full_name,
                                                  description: f.description, radius: f.radius,
                                                  created_at: f.created_at, entity_type: f.entity_type})
      }

      features_to_json = RGeo::GeoJSON.encode geo_factory.feature_collection(mapped_feats)
    end

    # codifica as equipas
    if new_or_updated_teams.size == 1
      ent = new_or_updated_teams.first
      team = team_factory.feature(User.find(ent.location_user_id).latlon, nil,
                                  {name: ent.name, f_id: ent.id, location_user_id: ent.location_user_id,
                                   created_at: ent.created_at, updated_at: ent.updated_at,
                                   location_user_name: User.find(ent.location_user_id).full_name,
                                   leader_name: User.find(TeamMember.where(team_id: ent.id, is_leader: true)
                                                              .first.user_id).full_name,
                                   leader_id: User.find(TeamMember.where(team_id: ent.id, is_leader: true)
                                                            .first.user_id).id})
      teams_to_json = RGeo::GeoJSON.encode team
    else
      # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
      # transformadas em json
      mapped_teams = team_factory.map_feature_collection(new_or_updated_teams) {
          |f| factory.feature(User.find(f.location_user_id).latlon, nil,
                              {name: f.name, f_id: f.id, location_user_id: f.location_user_id,
                               created_at: f.created_at, updated_at: f.updated_at,
                               location_user_name: User.find(f.location_user_id).full_name,
                               leader_name: User.find(TeamMember.where(team_id: f.id, is_leader: true)
                                                          .first.user_id).full_name,
                               leader_id: User.find(TeamMember.where(team_id: f.id, is_leader: true)
                                                        .first.user_id).id})
      }

      # dps do mapeamento, s�o enviadas para a fabrica que trata da transforma��o
      # para json para serem apresentadas no mapa
      teams_to_json = RGeo::GeoJSON.encode team_factory.feature_collection(mapped_teams)
    end

    begin
      if new_or_updated_geo_entity.size > 0 && new_or_updated_teams.size > 0
        # equipas e entidades novas para enviar
        puts "ENTIDADE NOVA E EQUIPA NOVA NOS ULTIMOS 20 SEGUNDOS"
        sse.write(features_to_json,
                  event: 'entity_updates', retry: 20000)
        sse.write(teams_to_json,
                  event: 'team_updates', retry: 20000)
      elsif new_or_updated_geo_entity.size > 0
        # apenas entidades novas para enviar
        puts "APENAS ENTIDADE NOVA NOS ULTIMOS 20 SEGUNDOS"
        sse.write(features_to_json,
                  event: 'entity_updates', retry: 20000)
      elsif new_or_updated_teams.size > 0
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
