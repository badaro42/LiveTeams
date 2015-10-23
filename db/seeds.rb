# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

first_names = ['Jose', 'Adolfo', 'Carlos', 'Antonio', 'Paulo', 'Ptara', 'Renato', 'Rafael', 'Bruno']

last_names = ['Balele', 'Bizarra', 'Dias', 'Aires', 'Bussaco', 'Costa', 'Alexandre', 'Socrates', 'Coelho']

team_names = ['PSP Feijo', 'Proteccao Civil Almada', 'Bombeiros Cacilhas', 'Grupo de populares', 'PSP Laranjeiro',
              'Fuzileiros', 'Marinha', 'Forca Aerea', 'Administradores', 'Policia Maritima']


# USERS first_name:string last_name:string email:string password:string avatar:imagem
puts 'Adding 20 random Users'
1.upto(20) do |i|
  t = nil
  if i == 1
    t = User.create(
        first_name: 'Admin',
        last_name: 'Poderoso',
        email: 'admin@mail.com',
        password: 'adminadmin',
        avatar: File.open(Rails.root + "app/assets/teste.png"),
        password_confirmation: 'adminadmin'
    )
  else
    r = Random.rand(10)
    r2 = Random.rand(12)
    t = User.create(
        first_name: first_names[(r+i)%first_names.length],
        last_name: last_names[(r2+i)%last_names.length],
        email: first_names[(r+i)%first_names.length]+''+i.to_s+'@mail.com',
        avatar: File.open(Rails.root + "app/assets/teste.png"),
        password: 'qweqweqwe',
        password_confirmation: 'qweqweqwe'
    )
  end
end


# TEAMS name:string latlon:geometry
# NOTA: AS COORDENADAS ESTAO INVERTIDAS: PRIMEIRO LONGITUDE, DPS LATITUDE
puts 'Adding 10 Teams'
Team.create(name: team_names[0], latlon: "POINT(-9.160860925912857 38.62768769514654)") # Vale de Milhaços
Team.create(name: team_names[1], latlon: "POINT(-9.203015863895416 38.661109791229485)") # FCT-UNL DI
Team.create(name: team_names[2], latlon: "POINT(-9.147389531135559 38.6874694378102)") # Metro Cacilhas
Team.create(name: team_names[3], latlon: "POINT(-9.160088449716568 38.65548397079349)") # Campos Ténis Feijó
Team.create(name: team_names[4], latlon: "POINT(-9.23403024673462 38.64389162826271)") # Costa da Caparica
Team.create(name: team_names[5], latlon: "POINT(-9.171277284622192 38.678508079563805)") # Cristo Rei
Team.create(name: team_names[6], latlon: "POINT(-9.136432707309723 38.70748187656837)") # Praça do Comércio
Team.create(name: team_names[7], latlon: "POINT(-9.094029664993286 38.76843921624117)") # Pavilhão Atlântico
Team.create(name: team_names[8], latlon: "POINT(-9.213436245918274 38.42022552818708)") # Cabo Espichel
Team.create(name: team_names[9], latlon: "POINT(-8.903088569641113 38.49027879470561)") # Península de Tróia


# TEAM_MEMBERS team_id:integer user_id:integer is_leader:boolean
puts 'Adding Team Members'
TeamMember.create(team_id: 1, user_id: 1, is_leader: true)
TeamMember.create(team_id: 1, user_id: 2, is_leader: false)
TeamMember.create(team_id: 2, user_id: 3, is_leader: true)
TeamMember.create(team_id: 3, user_id: 4, is_leader: false)
TeamMember.create(team_id: 3, user_id: 5, is_leader: true)
TeamMember.create(team_id: 3, user_id: 6, is_leader: false)
TeamMember.create(team_id: 4, user_id: 7, is_leader: true)
TeamMember.create(team_id: 5, user_id: 8, is_leader: true)
TeamMember.create(team_id: 6, user_id: 9, is_leader: true)
TeamMember.create(team_id: 6, user_id: 10, is_leader: false)
TeamMember.create(team_id: 6, user_id: 11, is_leader: false)
TeamMember.create(team_id: 6, user_id: 12, is_leader: false)
TeamMember.create(team_id: 6, user_id: 13, is_leader: false)
TeamMember.create(team_id: 7, user_id: 14, is_leader: true)
TeamMember.create(team_id: 7, user_id: 15, is_leader: false)
TeamMember.create(team_id: 7, user_id: 16, is_leader: false)
TeamMember.create(team_id: 8, user_id: 17, is_leader: true)
TeamMember.create(team_id: 9, user_id: 18, is_leader: false)
TeamMember.create(team_id: 9, user_id: 19, is_leader: true)
TeamMember.create(team_id: 10, user_id: 20, is_leader: true)


# TEAM_MEMBERS team_id:integer user_id:integer is_leader:boolean
puts 'Adding Geographic Entities'
GeoEntity.create(name: "Entrada para o Arsenal do Alfeite", user_id: 2, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.154230505228043 38.658546181023475)",
                 description: "Tambem conhecida por Portao Verde") # Portão Verde

GeoEntity.create(name: "Belo caminho por Portugal", user_id: 1, entity_type: "polyline", radius: 0,
                 latlon: "LINESTRING(-9.166889190673828 38.64583568648869, -8.715591430664062 39.257778150283336, " +
                  "-8.442392349243164 40.272715386988686, -8.231935501098633 40.305189027180226, " +
                  "-7.912387847900391 40.65095033081072, -7.702789306640625 41.306697618181886, " +
                  "-7.412896156311036 41.34846396411108)",
                 description: "Demora-se um bocado a chegar, mas a recompensa vale a pena") # Lisboa - Sta. Eugénia

GeoEntity.create(name: "Base Naval de Lisboa - Arsenal do Alfeite", user_id: 3, entity_type: "polygon", radius: 0,
                 latlon: "POLYGON((-9.157555103302002 38.66761893813652, -9.144165515899658 38.67324799343888, " +
                  "-9.128201007843018 38.65749892823337, -9.13764238357544 38.64811486000121, " +
                  "-9.145710468292236 38.6563594998049, -9.157555103302002 38.66761893813652))",
                 description: "Zona bem grande e com alguns navios porreiros") # Área do Arsenal do Alfeite