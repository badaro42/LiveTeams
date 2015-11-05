class HomepageController < ApplicationController
  include ActionController::Live

  def entity_updates
    require 'rgeo'
    require 'rgeo-geojson'

    ActiveRecord::Base.include_root_in_json = true
    response.headers['Content-Type'] = 'text/event-stream'

    puts "SERA QUE HA NOVA CENA!!!!????"
    sse = SSE.new(response.stream, retry: 20000, event: 'event_update')

    # devolve os utilizadores criados ou atualizados nos ultimos 25 segundos
    # new_or_updated_users = User.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
    #                                   15.minutes.ago, Time.now, 15.minutes.ago, Time.now)
    # # devolve os utilizadores criados ou atualizados nos ultimos 25 segundos
    # new_or_updated_teams = Team.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
    #                                   15.minutes.ago, Time.now, 15.minutes.ago, Time.now).to_json(include: :users)


    # devolve os utilizadores criados ou atualizados nos ultimos 25 segundos
    new_or_updated_geo_entity = GeoEntity.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
                                                20.seconds.ago, Time.now, 20.seconds.ago, Time.now)

    # if new_or_updated_users.size > 0 || new_or_updated_teams.size > 0 || new_or_updated_geo_entity.size > 0
    if new_or_updated_geo_entity.size > 0
      begin
        # cria a fabrica de entidades
        factory = RGeo::GeoJSON::EntityFactory.instance
        features_to_json = nil

        if new_or_updated_geo_entity.size == 1
          ent = new_or_updated_geo_entity.first
          feature = factory.feature(ent.latlon, nil, {name: ent.name, user_id: ent.user_id,
                                                      description: ent.description, radius: ent.radius})
          features_to_json = RGeo::GeoJSON.encode feature
        else
          # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
          # transformadas em json
          mapped_feats = factory.map_feature_collection(new_or_updated_geo_entity) {
              |f| factory.feature(f.latlon, nil, {name: f.name, user_id: f.user_id,
                                                  description: f.description, radius: f.radius})
          }

          # dps do mapeamento, s�o enviadas para a fabrica que trata da transforma��o
          # para json para serem apresentadas no mapa
          features_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_feats)
        end

        puts "ENTIDADE NOVA NOS ULTIMOS 20 SEGUNDOS"
        # sse.write([new_or_updated_users] + [new_or_updated_teams] + [new_or_updated_geo_entity],
        sse.write(features_to_json,
                  event: 'entity_updates', retry: 20000)
      rescue IOError
        # When the client disconnects, we'll get an IOError on write
      ensure
        puts "CLOSE cena cena"
        sse.close
      end
    else
      puts "NAO ENTROU NA CENA Da cena que da para cena"
      render :nothing => true, :status => 200, :content_type => 'text/html'
    end
  end


  # def user_update
  #   response.headers['Content-Type'] = 'text/event-stream'
  #
  #   puts "SERA QUE HA NOVO UTILIZADOR!!!!????"
  #   sse = SSE.new(response.stream, retry: 20000, event: 'user_update')
  #
  #   last_user = User.order('created_at DESC').first
  #
  #   # devolve os utilizadores criados ou atualizados nos ultimos 25 segundos
  #   new_or_updated_users = User.where("created_at between (?) and (?) OR updated_at between (?) and (?)",
  #                                     25.seconds.ago, Time.now, 25.seconds.ago, Time.now)
  #
  #   if new_or_updated_users.count > 0
  #     begin
  #       puts "UTILIZADOR NOVO NOS ULTIMOS 20 SEGUNDOS"
  #       sse.write(new_or_updated_users + last_user, event: 'user_update', retry: 20000)
  #     rescue IOError
  #       # When the client disconnects, we'll get an IOError on write
  #     ensure
  #       puts "CLOSE USER USER"
  #       sse.close
  #     end
  #   else
  #     puts "NAO ENTROU NA CENA DO USER"
  #     render :nothing => true, :status => 200, :content_type => 'text/html'
  #   end
  # end
  #
  # def team_update
  #   response.headers['Content-Type'] = 'text/event-stream'
  #
  #   puts "SERA QUE HA NOVA EQUIPA!!!!????"
  #   sse = SSE.new(response.stream, retry: 20000, event: 'team_update')
  #
  #   last_team = Team.order('created_at DESC').first
  #   if recently_changed? last_team
  #     begin
  #       puts "EQUIPA NOVO NOS ULTIMOS 20 SEGUNDOS"
  #       sse.write(last_team, event: 'team_update', retry: 20000)
  #     rescue IOError
  #       # When the client disconnects, we'll get an IOError on write
  #     ensure
  #       puts "CLOSE EQUIPA EQUIPA"
  #       sse.close
  #     end
  #   else
  #     puts "NAO ENTROU NA CENA DA EQUIPA"
  #     render :nothing => true, :status => 200, :content_type => 'text/html'
  #   end
  # end
  #
  # def geo_entity_update
  #   response.headers['Content-Type'] = 'text/event-stream'
  #
  #   puts "SERA QUE HA NOVA ENTIDADE!!!!????"
  #   sse = SSE.new(response.stream, retry: 20000, event: 'geo_entity_update')
  #
  #   last_geo_entity = GeoEntity.order('created_at DESC').first
  #   if recently_changed? last_geo_entity
  #     begin
  #       puts "ENTIDADE NOVA NOS ULTIMOS 20 SEGUNDOS"
  #       sse.write(last_geo_entity, event: 'geo_entity_update', retry: 20000)
  #     rescue IOError
  #       # When the client disconnects, we'll get an IOError on write
  #     ensure
  #       puts "CLOSE CLOSE ENTIDADE ENTIDADE"
  #       sse.close
  #     end
  #   else
  #     puts "NAO ENTROU NA CENA DA ENTIDADE ENTIDADE"
  #     render :nothing => true, :status => 200, :content_type => 'text/html'
  #   end
  # end

  def index
    @most_active_users = User.all.order(sign_in_count: :desc).limit(15)
    @recently_changed_teams = Team.all.order(updated_at: :desc).limit(15)
  end

  def get_geo_entities
    require 'rgeo'
    require 'rgeo-geojson'

    features = GeoEntity.all
    # puts features

    # cria a fabrica de entidades
    factory = RGeo::GeoJSON::EntityFactory.instance
    # puts factory

    # dps de obter todas as entidades do servidor, mapeia-as num objeto de forma a que sejam correctamente
    # transformadas em json
    mapped_feats = factory.map_feature_collection(features) {
        |f| factory.feature(f.latlon, nil, {name: f.name, user_id: f.user_id,
                                            description: f.description, radius: f.radius})
    }

    # puts mapped_feats

    # dps do mapeamento, s�o enviadas para a fabrica que trata da transforma��o para json para serem apresentadas no mapa
    features_to_json = RGeo::GeoJSON.encode factory.feature_collection(mapped_feats)

    # puts teste
    render json: features_to_json
  end

  # def recently_changed? object
  #   object.created_at > 25.seconds.ago or
  #       object.updated_at > 25.seconds.ago
  # end
end
