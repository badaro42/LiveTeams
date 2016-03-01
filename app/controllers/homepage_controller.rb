class HomepageController < ApplicationController
  include ActionController::Live
  before_filter :authenticate_user!
  require 'encode_to_json'
  layout "listings", only: :evaluation_form

  def geocode_location
    require 'geocoder'

    result = Geocoder.search(params[:location])
    render json: result.to_json
  end

  def index
    @most_active_users = User.all.order(sign_in_count: :desc).limit(15)
    @recently_changed_teams = Team.all.order(updated_at: :desc).limit(15)

    can_create_geo_entities = can_perform_action? :create, GeoEntity

    gon.push({
                 user_id: current_user.id,
                 current_lat: current_user.latlon.lat,
                 current_lon: current_user.latlon.lon,
                 can_create_geo_entities: can_create_geo_entities,
                 number_of_teams: current_user.teams.length,
                 current_profile: current_user.profile
             })
  end

  # metodo a ser usado apenas na avaliação!
  def evaluation_form
    if !show_evaluation_form?
      flash[:error] = "A página do questionário não está disponível. Contacte o administrador caso se trate de um erro."
      redirect_to root_path
    end
  end

  def entity_updates
    require 'rgeo'
    require 'rgeo-geojson'

    puts "SERA QUE HA NOVA CENA!!!!????"
    ActiveRecord::Base.include_root_in_json = true
    response.headers['Content-Type'] = 'text/event-stream'

    sse = SSE.new(response.stream, event: 'event_update')

    # devolve os utilizadores criados ou atualizados nos ultimos 22 segundos
    geo_entities_to_parse = GeoEntity.where("created_at between ? and ? OR updated_at between ? and ?",
                                            5.seconds.ago, Time.now, 5.seconds.ago, Time.now)
    # devolve as equipas criadas ou atualizadas nos ultimos 22 segundos
    teams_to_parse = Team.where("created_at between ? and ? OR updated_at between ? and ?",
                                5.seconds.ago, Time.now, 5.seconds.ago, Time.now)

    users_to_parse = User.where("created_at between ? and ? OR updated_at between ? and ?",
                                5.seconds.ago, Time.now, 5.seconds.ago, Time.now)

    # devolve as equipas e geo-entidade eliminadas nos ultimos 22 segundos
    rec_del_team_array = []
    rec_del_geo_ent_array = []
    rec_del_users_array = []

    rec_del_team_versions = PaperTrail::Version.where('event = ? and created_at > ? and item_type = ?',
                                                      'destroy', 5.seconds.ago, 'Team')
    rec_del_geo_ent_versions = PaperTrail::Version.where('event = ? and created_at > ? and item_type = ?',
                                                         'destroy', 5.seconds.ago, 'GeoEntity')
    rec_del_users_versions = PaperTrail::Version.where('event = ? and created_at > ? and item_type = ?',
                                                       'destroy', 5.seconds.ago, 'User')

    # pomos a data de atualização a nil para no javascript sabermos que é para remover
    rec_del_team_versions.each do |team|
      temp = team.reify
      temp.updated_at = nil
      rec_del_team_array.push(temp)
    end
    rec_del_geo_ent_versions.each do |geo_entity|
      temp = geo_entity.reify
      temp.updated_at = nil
      rec_del_geo_ent_array.push(temp)
    end
    rec_del_users_versions.each do |user|
      temp = user.reify
      temp.updated_at = nil
      rec_del_users_array.push(temp)
    end

    # uniao entre os 2 conjuntos
    teams_to_parse = teams_to_parse | rec_del_team_array
    geo_entities_to_parse = geo_entities_to_parse | rec_del_geo_ent_array
    users_to_parse = users_to_parse | rec_del_users_array

    geo_entities_to_json = EncodeToJson::encode_geo_entities_to_json(geo_entities_to_parse)
    teams_to_json = EncodeToJson::encode_teams_to_json(teams_to_parse)
    users_to_json = EncodeToJson::encode_users_to_json(users_to_parse)

    begin
      # as equipas a que o utilizador pertence
      team_ids_arr = current_user.get_user_teams_ids
      puts "------------------------------"
      puts team_ids_arr.inspect
      puts team_ids_arr.length
      puts "------------------------------"

      if geo_entities_to_parse.length > 0 || teams_to_parse.length > 0 || users_to_parse.length > 0 ||
          team_ids_arr.length > 0
        if team_ids_arr.length > 0
          puts "------ ESTE UTILIZADOR PERTENCE A PELO MENOS 1 EQUIPA ------"
          team_ids_json = team_ids_arr.to_json
          sse.write(team_ids_json, event: 'user_teams')
        end
        if geo_entities_to_parse.length > 0
          puts "****** NOVA GEO-ENTIDADE NOS ÚLTIMOS 3 SEGUNDOS ******"
          sse.write(geo_entities_to_json, event: 'geo_entity_updates')
        end
        if teams_to_parse.length > 0
          puts "++++++ NOVA EQUIPA NOS ÚLTIMOS 3 SEGUNDOS ++++++"
          sse.write(teams_to_json, event: 'team_updates')
        end
        if users_to_parse.length > 0
          puts "###### NOVO UTILIZADOR NOS ÚLTIMOS 3 SEGUNDOS ######"
          sse.write(users_to_json, event: 'user_updates')
        end
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
