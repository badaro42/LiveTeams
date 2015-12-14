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

    # devolve os utilizadores criados ou atualizados nos ultimos 22 segundos
    new_or_updated_geo_entity = GeoEntity.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
                                                22.seconds.ago, Time.now, 22.seconds.ago, Time.now)
    # devolve as equipas criadas ou atualizadas nos ultimos 22 segundos
    teams_to_parse = Team.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
                                22.seconds.ago, Time.now, 22.seconds.ago, Time.now)

    # devolve as equipas eliminadas nos ultimos 22 segundos
    recently_deleted_team_versions = PaperTrail::Version.where('event = ? and created_at > ?', 'destroy', 22.seconds.ago)
    recently_deleted_team_array = []

    puts recently_deleted_team_versions.inspect

    # pomos a data de atualização a nil para no javascript sabermos que é para remover
    recently_deleted_team_versions.each do |team|
      lol = team.reify
      lol.updated_at = nil
      recently_deleted_team_array.push(lol)
    end

    puts recently_deleted_team_array.inspect

    # uniao entre os 2 conjuntos
    teams_to_parse = teams_to_parse | recently_deleted_team_array

    # codifica as entidades geograficas
    if new_or_updated_geo_entity.size == 1
      f = new_or_updated_geo_entity.first
      feature = geo_factory.feature(f.latlon, nil, {f_id: f.id, name: f.name, username: User.find(f.user_id).full_name,
                                                    user_id: f.user_id, description: f.description, radius: f.radius,
                                                    created_at: f.created_at, entity_type: f.entity_type})
      features_to_json = RGeo::GeoJSON.encode feature
    else
      # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
      # transformadas em json
      mapped_feats = geo_factory.map_feature_collection(new_or_updated_geo_entity) {
          |f| geo_factory.feature(f.latlon, nil, {f_id: f.id, name: f.name, username: User.find(f.user_id).full_name,
                                                  user_id: f.user_id, description: f.description, radius: f.radius,
                                                  created_at: f.created_at, entity_type: f.entity_type})
      }

      features_to_json = RGeo::GeoJSON.encode geo_factory.feature_collection(mapped_feats)
    end

    # codifica as equipas
    if teams_to_parse.size == 1
      ent = teams_to_parse.first
      team = team_factory.feature(User.find(ent.location_user_id).latlon, nil,
                                  {name: ent.name, f_id: ent.id, location_user_id: ent.location_user_id,
                                   created_at: ent.created_at, updated_at: ent.updated_at,
                                   location_user_name: User.find(ent.location_user_id).full_name,
                                   leader_name: ((TeamMember.where(team_id: ent.id, is_leader: true) == []) ? "" :
                                       User.find(TeamMember.where(team_id: ent.id, is_leader: true).first.user_id).full_name),
                                   leader_id: ((TeamMember.where(team_id: ent.id, is_leader: true) == []) ? 0 :
                                       User.find(TeamMember.where(team_id: ent.id, is_leader: true).first.user_id).id)
                                  }
      )
      teams_to_json = RGeo::GeoJSON.encode team
    else
      # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
      # transformadas em json
      mapped_teams = team_factory.map_feature_collection(teams_to_parse) {
          |f| team_factory.feature(User.find(f.location_user_id).latlon, nil,
                                   {name: f.name, f_id: f.id, location_user_id: f.location_user_id,
                                    created_at: f.created_at, updated_at: f.updated_at,
                                    location_user_name: User.find(f.location_user_id).full_name,
                                    leader_name: ((TeamMember.where(team_id: f.id, is_leader: true) == []) ? "" :
                                        User.find(TeamMember.where(team_id: f.id, is_leader: true).first.user_id).full_name),
                                    leader_id: ((TeamMember.where(team_id: f.id, is_leader: true) == []) ? 0 :
                                        User.find(TeamMember.where(team_id: f.id, is_leader: true).first.user_id).id)
                                   }
        )
      }

      # dps do mapeamento, s�o enviadas para a fabrica que trata da transforma��o
      # para json para serem apresentadas no mapa
      teams_to_json = RGeo::GeoJSON.encode team_factory.feature_collection(mapped_teams)
    end

    begin
      if new_or_updated_geo_entity.size > 0 && teams_to_parse.size > 0
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
