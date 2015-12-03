# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

team_names = ['PSP Feijo', 'Proteccao Civil Almada', 'Bombeiros Cacilhas', 'Grupo de populares', 'PSP Laranjeiro',
              'Fuzileiros', 'Marinha', 'Forca Aerea', 'Administradores', 'Policia Maritima']


# USERS first_name:string last_name:string email:string password:string avatar:imagem
puts 'Adding 20 Users'

# id 1
User.create(first_name: 'Admin', last_name: 'Sistema', email: 'admin@mail.com', password: 'adminadmin',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'adminadmin',
            profile: User::ADMINISTRADOR, phone_number: '212111111',
            latlon: 'POINT(-9.160860925912857 38.62768769514654)') # Vale de Milha�os
# id 2
User.create(first_name: 'José', last_name: 'Sócrates', email: 'jose1@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111112',
            latlon: 'POINT(-9.203015863895416 38.661109791229485)') # FCT-UNL DI
# id 3
User.create(first_name: 'Manuel', last_name: 'Rebelo', email: 'manuel2@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111113',
            latlon: 'POINT(-9.147389531135559 38.6874694378102)') # Metro Cacilhas
# id 4
User.create(first_name: 'Renato', last_name: 'Alexandre', email: 'renato3@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::OPERACIONAL, phone_number: '212111114',
            latlon: 'POINT(-9.160088449716568 38.65548397079349)') # Campos T�nis Feij�
# id 5
User.create(first_name: 'Carlos', last_name: 'Dias', email: 'carlos4@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::OPERACIONAL, phone_number: '212111115',
            latlon: 'POINT(-9.23403024673462 38.64389162826271)') # Costa da Caparica
# id 6
User.create(first_name: 'Miguel', last_name: 'Alberto', email: 'miguel5@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111116',
            latlon: 'POINT(-9.171277284622192 38.678508079563805)') # Cristo Rei
# id 7
User.create(first_name: 'Bruno', last_name: 'Aleixo', email: 'bruno6@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111117',
            latlon: 'POINT(-9.136432707309723 38.70748187656837)') # Pra�a do Com�rcio
# id 8
User.create(first_name: 'Rui', last_name: 'Coelho', email: 'rui7@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111118',
            latlon: 'POINT(-9.094029664993286 38.76843921624117)') # Pavilh�o Atl�ntico
# id 9
User.create(first_name: 'Rafael', last_name: 'Bizarra', email: 'rafael8@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::ADMINISTRADOR, phone_number: '212111119',
            latlon: 'POINT(-9.213436245918274 38.42022552818708)') # Cabo Espichel
# id 10
User.create(first_name: 'Roberto', last_name: 'Frangueiro', email: 'roberto9@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111120',
            latlon: 'POINT(-8.903088569641113 38.49027879470561)') # Pen�nsula de Tr�ia
# id 11
User.create(first_name: 'Artur', last_name: 'Bacano', email: 'artur10@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111121',
            latlon: 'POINT(-9.22276496887207 38.6275996886131)')
# id 12
User.create(first_name: 'Álvaro', last_name: 'Branco', email: 'alvaro11@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111122',
            latlon: 'POINT(-9.081315994262695 38.626258623311166)')
# id 13
User.create(first_name: 'Rodrigo', last_name: 'Silva', email: 'rodrigo12@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111123',
            latlon: 'POINT(-9.095392227172852 38.5937971957727)')
# id 14
User.create(first_name: 'Valter', last_name: 'Costa', email: 'valter13@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111124',
            latlon: 'POINT(-9.323358535766602 38.680417696714684)')
# id 15
User.create(first_name: 'Diogo', last_name: 'Fonseca', email: 'diogo14@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111125',
            latlon: 'POINT(-9.20628547668457 38.69756846453178)')
# id 16
User.create(first_name: 'David', last_name: 'António', email: 'david15@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111126',
            latlon: 'POINT(-9.420175552368164 38.69408504756833)')
# id 17
User.create(first_name: 'António', last_name: 'Esteves', email: 'antonio16@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111127',
            latlon: 'POINT(-9.381723403930664 38.69676461413586)')
# id 18
User.create(first_name: 'Filipe', last_name: 'Jesus', email: 'filipe17@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111128',
            latlon: 'POINT(-9.298982620239258 38.659777730712534)')
# id 19
User.create(first_name: 'Adalberto', last_name: 'Feio', email: 'adalberto18@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111129',
            latlon: 'POINT(-9.257440567016602 38.662458581979436)')
# id 20
User.create(first_name: 'João', last_name: 'Rodrigues', email: 'joao19@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/teste.png"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111130',
            latlon: 'POINT(-9.105348587036133 38.666747735267805)')


# TEAMS name:string
# NOTA: AS COORDENADAS ESTAO INVERTIDAS: PRIMEIRO LONGITUDE, DPS LATITUDE
puts 'Adding 10 Teams'
Team.create(name: team_names[0])
Team.create(name: team_names[1])
Team.create(name: team_names[2])
Team.create(name: team_names[3])
Team.create(name: team_names[4])
Team.create(name: team_names[5])
Team.create(name: team_names[6])
Team.create(name: team_names[7])
Team.create(name: team_names[8])
Team.create(name: team_names[9])


# TEAM_MEMBERS team_id:integer user_id:integer is_leader:boolean
puts 'Adding Team Members'
TeamMember.create(team_id: 1, user_id: 1, is_leader: true)
TeamMember.create(team_id: 1, user_id: 2, is_leader: false)
TeamMember.create(team_id: 2, user_id: 3, is_leader: true)
TeamMember.create(team_id: 3, user_id: 4, is_leader: false)
TeamMember.create(team_id: 3, user_id: 5, is_leader: true)
TeamMember.create(team_id: 4, user_id: 7, is_leader: true)
TeamMember.create(team_id: 5, user_id: 8, is_leader: true)
TeamMember.create(team_id: 6, user_id: 9, is_leader: true)
TeamMember.create(team_id: 6, user_id: 10, is_leader: false)
TeamMember.create(team_id: 7, user_id: 14, is_leader: true)
TeamMember.create(team_id: 7, user_id: 15, is_leader: false)
TeamMember.create(team_id: 8, user_id: 17, is_leader: true)
TeamMember.create(team_id: 9, user_id: 19, is_leader: true)
TeamMember.create(team_id: 10, user_id: 20, is_leader: true)


puts 'Updating teams with location'
Team.update(1, location_user_id: 1, latlon: User.find(1).latlon)
Team.update(2, location_user_id: 3, latlon: User.find(3).latlon)
Team.update(3, location_user_id: 6, latlon: User.find(6).latlon)
Team.update(4, location_user_id: 7, latlon: User.find(7).latlon)
Team.update(5, location_user_id: 8, latlon: User.find(8).latlon)
Team.update(6, location_user_id: 11, latlon: User.find(11).latlon)
Team.update(7, location_user_id: 15, latlon: User.find(15).latlon)
Team.update(8, location_user_id: 17, latlon: User.find(17).latlon)
Team.update(9, location_user_id: 18, latlon: User.find(18).latlon)
Team.update(10, location_user_id: 20, latlon: User.find(20).latlon)


# TEAM_MEMBERS team_id:integer user_id:integer is_leader:boolean
puts 'Adding Geographic Entities'
GeoEntity.create(name: "Entrada para o Arsenal do Alfeite", user_id: 2, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.154230505228043 38.658546181023475)",
                 description: "Tambem conhecida por Portao Verde",
                 team_id: 5) # Port�o Verde

GeoEntity.create(name: "Belo caminho por Portugal", user_id: 1, entity_type: "polyline", radius: 0,
                 latlon: "LINESTRING(-9.166889190673828 38.64583568648869, -8.715591430664062 39.257778150283336, " +
                     "-8.442392349243164 40.272715386988686, -8.231935501098633 40.305189027180226, " +
                     "-7.912387847900391 40.65095033081072, -7.702789306640625 41.306697618181886, " +
                     "-7.412896156311036 41.34846396411108)",
                 description: "Demora-se um bocado a chegar, mas a recompensa vale a pena",
                 team_id: 3) # Lisboa - Sta. Eug�nia

GeoEntity.create(name: "Base Naval de Lisboa - Arsenal do Alfeite", user_id: 3, entity_type: "polygon", radius: 0,
                 latlon: "POLYGON((-9.157555103302002 38.66761893813652, -9.144165515899658 38.67324799343888, " +
                     "-9.128201007843018 38.65749892823337, -9.13764238357544 38.64811486000121, " +
                     "-9.145710468292236 38.6563594998049, -9.157555103302002 38.66761893813652))",
                 description: "Zona bem grande e com alguns navios porreiros",
                 team_id: 1) # �rea do Arsenal do Alfeite