# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

team_names = ['PSP Feijo', 'Proteccao Civil Almada', 'Bombeiros Cacilhas', 'Grupo de populares', 'PSP Laranjeiro',
              'Fuzileiros', 'Marinha', 'Forca Aerea', 'Administradores', 'Policia Maritima']

# USER first_name:string last_name:string email:string password:string avatar:imagem
puts 'Adding 20 Users'

# id 1
User.create(first_name: 'Admin', last_name: 'Sistema', email: 'admin@mail.com', password: 'adminadmin',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_1.jpg"), password_confirmation: 'adminadmin',
            profile: Role::ADMINISTRADOR, phone_number: '212111111',
            latlon: 'POINT(-9.160860925912857 38.62768769514654)') # Vale de Milha�os
# id 2
User.create(first_name: 'José', last_name: 'Sócrates', email: 'jose_socrates@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::GESTOR, phone_number: '212111112',
            latlon: 'POINT(-9.203015863895416 38.661109791229485)') # FCT-UNL DI
# id 3
User.create(first_name: 'Joana', last_name: 'Marques', email: 'joana_marques@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_1.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::GESTOR, phone_number: '212111113',
            latlon: 'POINT(-9.147389531135559 38.6874694378102)') # Metro Cacilhas
# id 4
User.create(first_name: 'Renato', last_name: 'Alexandre', email: 'renato_alexandre@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_1.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::OPERACIONAL, phone_number: '212111114',
            latlon: 'POINT(-9.160088449716568 38.65548397079349)') # Campos T�nis Feij�
# id 5
User.create(first_name: 'Filipa', last_name: 'Dias', email: 'filipa_dias@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_4.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::OPERACIONAL, phone_number: '212111115',
            latlon: 'POINT(-9.23403024673462 38.64389162826271)') # Costa da Caparica
# id 6
User.create(first_name: 'Miguel', last_name: 'Alberto', email: 'miguel_alberto@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_4.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::OPERACIONAL, phone_number: '212111116',
            latlon: 'POINT(-9.171277284622192 38.678508079563805)') # Cristo Rei
# id 7
User.create(first_name: 'Bruno', last_name: 'Aleixo', email: 'bruno_aleixo@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_5.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::OPERACIONAL, phone_number: '212111117',
            latlon: 'POINT(-9.136432707309723 38.70748187656837)') # Pra�a do Com�rcio
# id 8
User.create(first_name: 'Antónia', last_name: 'Coelho', email: 'antonia_coelho@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::GESTOR, phone_number: '212111118',
            latlon: 'POINT(-9.094029664993286 38.76843921624117)') # Pavilh�o Atl�ntico
# id 9
User.create(first_name: 'Rafael', last_name: 'Bizarra', email: 'rafael_bizarra@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::ADMINISTRADOR, phone_number: '212111119',
            latlon: 'POINT(-9.213436245918274 38.42022552818708)') # Cabo Espichel
# id 10
User.create(first_name: 'Roberta', last_name: 'Frangueira', email: 'roberta_frangueira@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_3.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::OPERACIONAL, phone_number: '212111120',
            latlon: 'POINT(-8.903088569641113 38.49027879470561)') # Pen�nsula de Tr�ia
# id 11
User.create(first_name: 'Maria', last_name: 'Alves', email: 'maria_alves@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_5.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::GESTOR, phone_number: '212111121',
            latlon: 'POINT(-9.22276496887207 38.6275996886131)')
# id 12
User.create(first_name: 'Álvaro', last_name: 'Branco', email: 'alvaro_branco@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_3.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::GESTOR, phone_number: '212111122',
            latlon: 'POINT(-9.081315994262695 38.626258623311166)')
# id 13
User.create(first_name: 'Patrícia', last_name: 'Silva', email: 'patricia_silva@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_3.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::GESTOR, phone_number: '212111123',
            latlon: 'POINT(-9.095392227172852 38.5937971957727)')
# id 14
User.create(first_name: 'Valter', last_name: 'Costa', email: 'valter_costa@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_5.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::BASICO, phone_number: '212111124',
            latlon: 'POINT(-9.323358535766602 38.680417696714684)')
# id 15
User.create(first_name: 'Diogo', last_name: 'Fonseca', email: 'diogo_fonseca@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_1.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::ADMINISTRADOR, phone_number: '212111125',
            latlon: 'POINT(-9.20628547668457 38.69756846453178)')
# id 16
User.create(first_name: 'Rita', last_name: 'Nobre', email: 'rita_nobre@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_1.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::BASICO, phone_number: '212111126',
            latlon: 'POINT(-9.420175552368164 38.69408504756833)')
# id 17
User.create(first_name: 'António', last_name: 'Esteves', email: 'antonio_esteves@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_4.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::GESTOR, phone_number: '212111127',
            latlon: 'POINT(-9.381723403930664 38.69676461413586)')
# id 18
User.create(first_name: 'Filipe', last_name: 'Jesus', email: 'filipe_jesus@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::OPERACIONAL, phone_number: '212111128',
            latlon: 'POINT(-9.298982620239258 38.659777730712534)')
# id 19
User.create(first_name: 'Ana', last_name: 'Henrique', email: 'ana_henrique@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_4.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::GESTOR, phone_number: '212111129',
            latlon: 'POINT(-9.257440567016602 38.662458581979436)')
# id 20
User.create(first_name: 'Inês', last_name: 'Rodrigues', email: 'ines_rodrigues@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: Role::OPERACIONAL, phone_number: '212111130',
            latlon: 'POINT(-9.105348587036133 38.666747735267805)')


# TEAM name:string
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


# TEAM_MEMBER team_id:integer user_id:integer is_leader:boolean
puts 'Adding Team Members'
TeamMember.create(team_id: 1, user_id: 1)
TeamMember.create(team_id: 1, user_id: 2)

TeamMember.create(team_id: 2, user_id: 2)
TeamMember.create(team_id: 2, user_id: 3)
TeamMember.create(team_id: 2, user_id: 12)

TeamMember.create(team_id: 3, user_id: 1)
TeamMember.create(team_id: 3, user_id: 4)
TeamMember.create(team_id: 3, user_id: 6)
TeamMember.create(team_id: 3, user_id: 13)
TeamMember.create(team_id: 3, user_id: 19)

TeamMember.create(team_id: 4, user_id: 7)
TeamMember.create(team_id: 4, user_id: 13)
TeamMember.create(team_id: 4, user_id: 20)

TeamMember.create(team_id: 5, user_id: 8)
TeamMember.create(team_id: 5, user_id: 17)

TeamMember.create(team_id: 6, user_id: 5)
TeamMember.create(team_id: 6, user_id: 9)
TeamMember.create(team_id: 6, user_id: 10)
TeamMember.create(team_id: 6, user_id: 11)

TeamMember.create(team_id: 7, user_id: 15)
TeamMember.create(team_id: 7, user_id: 17)

TeamMember.create(team_id: 8, user_id: 1)
TeamMember.create(team_id: 8, user_id: 9)
TeamMember.create(team_id: 8, user_id: 18)

TeamMember.create(team_id: 9, user_id: 2)
TeamMember.create(team_id: 9, user_id: 8)
TeamMember.create(team_id: 9, user_id: 19)

TeamMember.create(team_id: 10, user_id: 11)
TeamMember.create(team_id: 10, user_id: 18)
TeamMember.create(team_id: 10, user_id: 20)


puts 'Updating teams with location and leader'
Team.update(1, created_by_user_id: 1, leader_id: 1, location_user_id: 1, latlon: User.find(1).latlon)
Team.update(2, created_by_user_id: 3, leader_id: 3, location_user_id: 3, latlon: User.find(3).latlon)
Team.update(3, created_by_user_id: 19, leader_id: 19, location_user_id: 6, latlon: User.find(6).latlon)
Team.update(4, created_by_user_id: 13, leader_id: 13, location_user_id: 7, latlon: User.find(7).latlon)
Team.update(5, created_by_user_id: 8, leader_id: 8, location_user_id: 8, latlon: User.find(8).latlon)
Team.update(6, created_by_user_id: 11, leader_id: 11, location_user_id: 11, latlon: User.find(11).latlon)
Team.update(7, created_by_user_id: 15, leader_id: 15, location_user_id: 15, latlon: User.find(15).latlon)
Team.update(8, created_by_user_id: 18, leader_id: 18, location_user_id: 18, latlon: User.find(18).latlon)
Team.update(9, created_by_user_id: 2, leader_id: 2, location_user_id: 19, latlon: User.find(19).latlon)
Team.update(10, created_by_user_id: 11, leader_id: 11, location_user_id: 20, latlon: User.find(20).latlon)


# CATEGORY name:string
puts 'Adding categories'
Category.create(name: "Urgente") # ID 1; icone vermelho
Category.create(name: "Perigo") # ID 2; icone laranja
# Category.create(name: "Alerta") # icone amarelo
Category.create(name: "Resolvido") # ID 3; icone verde
Category.create(name: "Informação") # ID 4; icone azul
Category.create(name: "Outros") # ID 5; icone acinzentado


# GEO_ENTITY name:string user_id:integer entity_type:string radius:integer latlon:coordinates description:string
puts 'Adding Geographic Entities'
GeoEntity.create(name: "Entrada para o Arsenal do Alfeite", user_id: 2, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.154230505228043 38.658546181023475)",
                 description: "Tambem conhecida por Portao Verde", category_id: 2) # ID 1

GeoEntity.create(name: "Belo caminho por Portugal", user_id: 1, entity_type: "polyline", radius: 0,
                 latlon: "LINESTRING(-9.166889190673828 38.64583568648869, -8.715591430664062 39.257778150283336, " +
                     "-8.442392349243164 40.272715386988686, -8.231935501098633 40.305189027180226, " +
                     "-7.912387847900391 40.65095033081072, -7.702789306640625 41.306697618181886, " +
                     "-7.412896156311036 41.34846396411108)",
                 description: "Demora-se um bocado a chegar, mas a recompensa vale a pena", category_id: 3) # ID 2

GeoEntity.create(name: "Base Naval de Lisboa - Arsenal do Alfeite", user_id: 3, entity_type: "polygon", radius: 0,
                 latlon: "POLYGON((-9.157555103302002 38.66761893813652, -9.144165515899658 38.67324799343888, " +
                     "-9.128201007843018 38.65749892823337, -9.13764238357544 38.64811486000121, " +
                     "-9.145710468292236 38.6563594998049, -9.157555103302002 38.66761893813652))",
                 description: "Zona bem grande e com alguns navios porreiros", category_id: 1) # ID 3

GeoEntity.create(name: "Área afectada pelas cheias", user_id: 1, entity_type: "polygon", radius: 0,
                 latlon: "POLYGON((-9.241604804992676 38.64414301807133, -9.235403537750244 38.63747250975212, " +
                     "-9.232399463653564 38.63859547797987, -9.234330654144287 38.64263466599115, " +
                     "-9.236605167388916 38.643941906294984, -9.237592220306396 38.64586920427144, " +
                     "-9.240617752075195 38.64529939983218, -9.240210056304932 38.644645795042905))",
                 description: "Este polígono representa a área que está afectada pelas cheias de dia 20 de janeiro",
                 category_id: 2) # ID 4

GeoEntity.create(name: "Charneca da Caparica - Perigo", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.203710556030273 38.63135453802258)",
                 description: "Árvore caída a obstruir a estrada", category_id: 2) # ID 5

GeoEntity.create(name: "Vale Figueira - Perigo", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.178390502929688 38.62733147755926)",
                 description: "Estrada inundada, sargeta entipuda", category_id: 2) # ID 6

GeoEntity.create(name: "Informação à beira do Aterro Sanitário", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.14637565612793 38.61861407216631)",
                 description: "Teste de cluster com o outro ao lado", category_id: 4) # ID 7

GeoEntity.create(name: "Resolvido, para os lados do Talaminho", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.14186954498291 38.62293937883101)",
                 description: "É com este que se faz o teste de cluster :)", category_id: 3) # ID 8

GeoEntity.create(name: "Um polígono em cima da Amora", user_id: 1, entity_type: "polygon", radius: 0,
                 latlon: "POLYGON((-9.121055603027344 38.6329636990003, -9.107322692871094 38.631622734027125, " +
                     "-9.107322692871094 38.6255880812546, -9.117107391357422 38.62303996425438, " +
                     "-9.12689208984375 38.623844642562396, -9.125862121582031 38.62974534092597))",
                 description: "Deve ser cinzento, categoria dos outros",
                 category_id: 5) # ID 9

GeoEntity.create(name: "Baía do Seixal", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.103031158447266 38.64167935991964)",
                 description: "Zona muito bonita, a ver o rio.", category_id: 4) # ID 10

GeoEntity.create(name: "Acidente grave na A2", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.158134460449219 38.640003353587836)",
                 description: "Sentido Norte-Sul, carro capotado", category_id: 1) # ID 11

GeoEntity.create(name: "Vale do Grou - Resolvido", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.189891815185547 38.641277121974554)",
                 description: "Via desobstruída, árvore caída removida", category_id: 3) # ID 12

GeoEntity.create(name: "Bairro residencial Monte da Caparica", user_id: 1, entity_type: "rectangle", radius: 0,
                 latlon: "POLYGON((-9.200706481933594 38.6616543371365, -9.200706481933594 38.667149830216715, " +
                     "-9.190406799316404 38.667149830216715, -9.190406799316404 38.6616543371365))",
                 description: "Era só para testar esta coisa das categorias", category_id: 4) # ID 13

GeoEntity.create(name: "Posto de Controlo Móvel da Proteção Civil", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.234051704406738 38.64595299865978)",
                 description: "Estas coordenadas representam o posto de controlo móvel montado por causa das cheias",
                 category_id: 4) # ID 14

GeoEntity.create(name: "ESTRADA CORTADA", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.240124225616455 38.643874868910785)",
                 description: "Estrada intransitável, a água atinge 1 metro, prosseguir antes pela AVENIDA DAS ANDORINHAS",
                 category_id: 1) # ID 15

GeoEntity.create(name: "Habitação 3: situação resolvida", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.23750638961792 38.64318773210687)",
                 description: "O auxílo foi prestado. Cave inundada já está normalizada;",
                 category_id: 3) # ID 16

GeoEntity.create(name: "Habitação 2: pede auxílio", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.236712455749512 38.642332991765365)",
                 description: "Piso térreo alagado. Idosa acamada precisa de ambulância;",
                 category_id: 2) # ID 17

GeoEntity.create(name: "Muro desabou", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.235564470291138 38.64216539442453)",
                 description: "Muro desabou para a via pública. 1 pessoa ferida, possivelmente perna partida",
                 category_id: 2) # ID 18

GeoEntity.create(name: "Restaurante 'Come Aqui: Bom e Barato': pede auxílio", user_id: 1, entity_type: "marker",
                 radius: 0, latlon: "POINT(-9.235832691192627 38.640636050583296)",
                 description: "Várias pessoas dentro do restaurante; Incendio começou num curto-circuito na cave: " +
                     "risco de explosão das botijas de gás; 5 feridos ligeiros devido a inalação de fumo",
                 category_id: 1) # ID 19

GeoEntity.create(name: "Habitação 1: pede auxílio", user_id: 1, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.234459400177002 38.640246376935494)",
                 description: "Garagem/cave alagada",
                 category_id: 2) # ID 20

GeoEntity.create(name: "Idoso diz que perdeu 50 euros", user_id: 1, entity_type: "circle", radius: 20,
                 latlon: "POINT(-9.231981039047241 38.64074918124551)",
                 description: "Idoso perdeu o dinheiro quando fugia do vendaval e dos trovões; " +
                     "Não é urgente, a não ser que alguém esteja com dificuldades económicas",
                 category_id: 5) # ID 21


# TEAM_GEO_ENTITY team_id:integer geo_entity_id:integer
TeamGeoEntity.create(geo_entity_id: 1, team_id: 5)
TeamGeoEntity.create(geo_entity_id: 1, team_id: 7)

TeamGeoEntity.create(geo_entity_id: 2, team_id: 2)
TeamGeoEntity.create(geo_entity_id: 2, team_id: 3)
TeamGeoEntity.create(geo_entity_id: 2, team_id: 6)
TeamGeoEntity.create(geo_entity_id: 2, team_id: 8)

TeamGeoEntity.create(geo_entity_id: 3, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 3, team_id: 4)

TeamGeoEntity.create(geo_entity_id: 4, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 4, team_id: 2)
TeamGeoEntity.create(geo_entity_id: 4, team_id: 3)
TeamGeoEntity.create(geo_entity_id: 4, team_id: 4)
TeamGeoEntity.create(geo_entity_id: 4, team_id: 5)
TeamGeoEntity.create(geo_entity_id: 4, team_id: 6)
TeamGeoEntity.create(geo_entity_id: 4, team_id: 7)
TeamGeoEntity.create(geo_entity_id: 4, team_id: 8)
TeamGeoEntity.create(geo_entity_id: 4, team_id: 9)
TeamGeoEntity.create(geo_entity_id: 4, team_id: 10)

TeamGeoEntity.create(geo_entity_id: 5, team_id: 8)
TeamGeoEntity.create(geo_entity_id: 5, team_id: 9)

TeamGeoEntity.create(geo_entity_id: 6, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 6, team_id: 3)
TeamGeoEntity.create(geo_entity_id: 6, team_id: 6)
TeamGeoEntity.create(geo_entity_id: 6, team_id: 7)

TeamGeoEntity.create(geo_entity_id: 7, team_id: 4)

TeamGeoEntity.create(geo_entity_id: 8, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 8, team_id: 2)
TeamGeoEntity.create(geo_entity_id: 8, team_id: 6)
TeamGeoEntity.create(geo_entity_id: 8, team_id: 7)
TeamGeoEntity.create(geo_entity_id: 8, team_id: 8)

TeamGeoEntity.create(geo_entity_id: 9, team_id: 4)
TeamGeoEntity.create(geo_entity_id: 9, team_id: 5)
TeamGeoEntity.create(geo_entity_id: 9, team_id: 6)

TeamGeoEntity.create(geo_entity_id: 10, team_id: 3)
TeamGeoEntity.create(geo_entity_id: 10, team_id: 6)

TeamGeoEntity.create(geo_entity_id: 11, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 11, team_id: 2)
TeamGeoEntity.create(geo_entity_id: 11, team_id: 4)

TeamGeoEntity.create(geo_entity_id: 12, team_id: 5)
TeamGeoEntity.create(geo_entity_id: 12, team_id: 8)

TeamGeoEntity.create(geo_entity_id: 13, team_id: 10)

TeamGeoEntity.create(geo_entity_id: 14, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 14, team_id: 2)
TeamGeoEntity.create(geo_entity_id: 14, team_id: 3)
TeamGeoEntity.create(geo_entity_id: 14, team_id: 4)
TeamGeoEntity.create(geo_entity_id: 14, team_id: 5)
TeamGeoEntity.create(geo_entity_id: 14, team_id: 6)
TeamGeoEntity.create(geo_entity_id: 14, team_id: 7)
TeamGeoEntity.create(geo_entity_id: 14, team_id: 8)
TeamGeoEntity.create(geo_entity_id: 14, team_id: 9)
TeamGeoEntity.create(geo_entity_id: 14, team_id: 10)

TeamGeoEntity.create(geo_entity_id: 15, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 15, team_id: 2)
TeamGeoEntity.create(geo_entity_id: 15, team_id: 3)
TeamGeoEntity.create(geo_entity_id: 15, team_id: 4)
TeamGeoEntity.create(geo_entity_id: 15, team_id: 5)
TeamGeoEntity.create(geo_entity_id: 15, team_id: 6)
TeamGeoEntity.create(geo_entity_id: 15, team_id: 7)
TeamGeoEntity.create(geo_entity_id: 15, team_id: 8)
TeamGeoEntity.create(geo_entity_id: 15, team_id: 9)
TeamGeoEntity.create(geo_entity_id: 15, team_id: 10)

TeamGeoEntity.create(geo_entity_id: 16, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 16, team_id: 2)
TeamGeoEntity.create(geo_entity_id: 16, team_id: 4)

TeamGeoEntity.create(geo_entity_id: 17, team_id: 5)
TeamGeoEntity.create(geo_entity_id: 17, team_id: 6)

TeamGeoEntity.create(geo_entity_id: 18, team_id: 3)
TeamGeoEntity.create(geo_entity_id: 18, team_id: 6)
TeamGeoEntity.create(geo_entity_id: 18, team_id: 7)

TeamGeoEntity.create(geo_entity_id: 19, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 19, team_id: 2)
TeamGeoEntity.create(geo_entity_id: 19, team_id: 3)
TeamGeoEntity.create(geo_entity_id: 19, team_id: 5)
TeamGeoEntity.create(geo_entity_id: 19, team_id: 6)
TeamGeoEntity.create(geo_entity_id: 19, team_id: 7)
TeamGeoEntity.create(geo_entity_id: 19, team_id: 10)

TeamGeoEntity.create(geo_entity_id: 20, team_id: 1)

TeamGeoEntity.create(geo_entity_id: 21, team_id: 1)
TeamGeoEntity.create(geo_entity_id: 21, team_id: 1)


# PERMISSION subject_class:string subject_action:string
puts 'Adding Permissions'
Permission.create(subject_class: Permission::CLASS_USER, subject_action: Permission::ACTION_CREATE) #1: user create
Permission.create(subject_class: Permission::CLASS_USER, subject_action: Permission::ACTION_READ) #2: user read
Permission.create(subject_class: Permission::CLASS_USER, subject_action: Permission::ACTION_UPDATE_OWN) #3: user update own profile
Permission.create(subject_class: Permission::CLASS_USER, subject_action: Permission::ACTION_UPDATE_ALL) #4: user update all profiles
Permission.create(subject_class: Permission::CLASS_USER, subject_action: Permission::ACTION_DESTROY_OWN) #5: user destroy own account
Permission.create(subject_class: Permission::CLASS_USER, subject_action: Permission::ACTION_DESTROY_ALL) #6: user destroy all accounts

Permission.create(subject_class: Permission::CLASS_TEAM, subject_action: Permission::ACTION_CREATE) #7: team create
Permission.create(subject_class: Permission::CLASS_TEAM, subject_action: Permission::ACTION_READ) #8: team read
Permission.create(subject_class: Permission::CLASS_TEAM, subject_action: Permission::ACTION_UPDATE_OWN) #9: team update own teams
Permission.create(subject_class: Permission::CLASS_TEAM, subject_action: Permission::ACTION_UPDATE_ALL) #10: team update all teams
Permission.create(subject_class: Permission::CLASS_TEAM, subject_action: Permission::ACTION_DESTROY_OWN) #11: team destroy own teams
Permission.create(subject_class: Permission::CLASS_TEAM, subject_action: Permission::ACTION_DESTROY_ALL) #12: team destroy all teams

Permission.create(subject_class: Permission::CLASS_TEAM_MEMBER, subject_action: Permission::ACTION_CREATE) #13: team_member create
Permission.create(subject_class: Permission::CLASS_TEAM_MEMBER, subject_action: Permission::ACTION_READ) #14: team_member read
Permission.create(subject_class: Permission::CLASS_TEAM_MEMBER, subject_action: Permission::ACTION_UPDATE_ALL) #15: team_member update
Permission.create(subject_class: Permission::CLASS_TEAM_MEMBER, subject_action: Permission::ACTION_DESTROY_ALL) #16: team_member destroy

Permission.create(subject_class: Permission::CLASS_GEO_ENTITY, subject_action: Permission::ACTION_CREATE) #17: geo_entity create
Permission.create(subject_class: Permission::CLASS_GEO_ENTITY, subject_action: Permission::ACTION_READ) #18: geo_entity read
Permission.create(subject_class: Permission::CLASS_GEO_ENTITY, subject_action: Permission::ACTION_UPDATE_ALL) #19: geo_entity update
Permission.create(subject_class: Permission::CLASS_GEO_ENTITY, subject_action: Permission::ACTION_DESTROY_OWN) #20: geo_entity destroy own
Permission.create(subject_class: Permission::CLASS_GEO_ENTITY, subject_action: Permission::ACTION_DESTROY_ALL) #21: geo_entity destroy all

Permission.create(subject_class: Permission::CLASS_USER_ROLE, subject_action: Permission::ACTION_CREATE) #22: user_role create
Permission.create(subject_class: Permission::CLASS_USER_ROLE, subject_action: Permission::ACTION_READ) #23: user_role read
Permission.create(subject_class: Permission::CLASS_USER_ROLE, subject_action: Permission::ACTION_DESTROY_ALL) #24: user_role destroy all


# ROLE name:string permission_ids:array de strings
puts 'Adding Roles'
Role.create(name: Role::ADMINISTRADOR)
Role.create(name: Role::GESTOR)
Role.create(name: Role::OPERACIONAL)
Role.create(name: Role::BASICO)

Role.create(name: Role::USER_UPDATE_ALL)
Role.create(name: Role::USER_DESTROY_ALL)
Role.create(name: Role::TEAM_CREATE)
Role.create(name: Role::TEAM_UPDATE_OWN)
Role.create(name: Role::TEAM_UPDATE_ALL)
Role.create(name: Role::TEAM_DESTROY_OWN)
Role.create(name: Role::TEAM_DESTROY_ALL)
Role.create(name: Role::TEAM_MEMBER_CREATE)
Role.create(name: Role::TEAM_MEMBER_DESTROY)
Role.create(name: Role::GEO_ENTITY_CREATE)
Role.create(name: Role::GEO_ENTITY_REMOVE_OWN)
Role.create(name: Role::GEO_ENTITY_REMOVE_ALL)
Role.create(name: Role::MANAGE_TEMPORARY_USER_ROLES)


# ROLE_PERMISSION role_id:integer permission_id
puts 'Associating permissions to roles'
RolePermission.create(role_id: 1, permission_id: 2) # ADMINISTRADOR
RolePermission.create(role_id: 1, permission_id: 4)
RolePermission.create(role_id: 1, permission_id: 6)
RolePermission.create(role_id: 1, permission_id: 7)
RolePermission.create(role_id: 1, permission_id: 8)
RolePermission.create(role_id: 1, permission_id: 10)
RolePermission.create(role_id: 1, permission_id: 12)
RolePermission.create(role_id: 1, permission_id: 13)
RolePermission.create(role_id: 1, permission_id: 14)
RolePermission.create(role_id: 1, permission_id: 16)
RolePermission.create(role_id: 1, permission_id: 17)
RolePermission.create(role_id: 1, permission_id: 18)
RolePermission.create(role_id: 1, permission_id: 21)
RolePermission.create(role_id: 1, permission_id: 22)
RolePermission.create(role_id: 1, permission_id: 23)
RolePermission.create(role_id: 1, permission_id: 24)

RolePermission.create(role_id: 2, permission_id: 2) # GESTOR
RolePermission.create(role_id: 2, permission_id: 3)
RolePermission.create(role_id: 2, permission_id: 5)
RolePermission.create(role_id: 2, permission_id: 7)
RolePermission.create(role_id: 2, permission_id: 8)
RolePermission.create(role_id: 2, permission_id: 9)
RolePermission.create(role_id: 2, permission_id: 11)
RolePermission.create(role_id: 2, permission_id: 13)
RolePermission.create(role_id: 2, permission_id: 14)
RolePermission.create(role_id: 2, permission_id: 16)
RolePermission.create(role_id: 2, permission_id: 17)
RolePermission.create(role_id: 2, permission_id: 18)
RolePermission.create(role_id: 2, permission_id: 21)

RolePermission.create(role_id: 3, permission_id: 2) # OPERACIONAL
RolePermission.create(role_id: 3, permission_id: 3)
RolePermission.create(role_id: 3, permission_id: 5)
RolePermission.create(role_id: 3, permission_id: 8)
RolePermission.create(role_id: 3, permission_id: 14)
RolePermission.create(role_id: 3, permission_id: 17)
RolePermission.create(role_id: 3, permission_id: 18)
RolePermission.create(role_id: 3, permission_id: 20)

RolePermission.create(role_id: 4, permission_id: 2) # BASICO
RolePermission.create(role_id: 4, permission_id: 3)
RolePermission.create(role_id: 4, permission_id: 5)
RolePermission.create(role_id: 4, permission_id: 8)
RolePermission.create(role_id: 4, permission_id: 14)
RolePermission.create(role_id: 4, permission_id: 18)

RolePermission.create(role_id: 5, permission_id: 4) # USER_UPDATE_ALL

RolePermission.create(role_id: 6, permission_id: 6) # USER_DESTROY_ALL

RolePermission.create(role_id: 7, permission_id: 7) # TEAM_CREATE

RolePermission.create(role_id: 8, permission_id: 9) # TEAM_UPDATE_OWN

RolePermission.create(role_id: 9, permission_id: 10) # TEAM_UPDATE_ALL

RolePermission.create(role_id: 10, permission_id: 11) # TEAM_DESTROY_OWN

RolePermission.create(role_id: 11, permission_id: 12) # TEAM_DESTROY_ALL

RolePermission.create(role_id: 12, permission_id: 13) # TEAM_MEMBER_CREATE

RolePermission.create(role_id: 13, permission_id: 16) # TEAM_MEMBER_DESTROY

RolePermission.create(role_id: 14, permission_id: 17) # GEO_ENTITY_CREATE

RolePermission.create(role_id: 15, permission_id: 20) # GEO_ENTITY_REMOVE_OWN

RolePermission.create(role_id: 16, permission_id: 21) # GEO_ENTITY_REMOVE_ALL

RolePermission.create(role_id: 17, permission_id: 22) # MANAGE_PERMISSIONS
RolePermission.create(role_id: 17, permission_id: 23)
RolePermission.create(role_id: 17, permission_id: 24)




# USER_ROLE user_id:integer role_id:integer expiration_date:date
puts 'Associating roles to users'
UserRole.create(user_id: 1, role_id: 1, expiration_date: 10.years.since) # admin
UserRole.create(user_id: 2, role_id: 2, expiration_date: 10.years.since) # gestor
UserRole.create(user_id: 3, role_id: 2, expiration_date: 10.years.since) # gestor
UserRole.create(user_id: 4, role_id: 3, expiration_date: 10.years.since) # operacional
UserRole.create(user_id: 5, role_id: 3, expiration_date: 10.years.since) # operacional
UserRole.create(user_id: 6, role_id: 3, expiration_date: 10.years.since) # operacional
UserRole.create(user_id: 7, role_id: 3, expiration_date: 10.years.since) # operacional
UserRole.create(user_id: 8, role_id: 2, expiration_date: 10.years.since) # gestor
UserRole.create(user_id: 9, role_id: 1, expiration_date: 10.years.since) # admin
UserRole.create(user_id: 10, role_id: 3, expiration_date: 10.years.since) # operacional
UserRole.create(user_id: 11, role_id: 2, expiration_date: 10.years.since) # gestor
UserRole.create(user_id: 12, role_id: 2, expiration_date: 10.years.since) # gestor
UserRole.create(user_id: 13, role_id: 2, expiration_date: 10.years.since) # gestor
UserRole.create(user_id: 14, role_id: 4, expiration_date: 10.years.since) # basico
UserRole.create(user_id: 15, role_id: 1, expiration_date: 10.years.since) # admin
UserRole.create(user_id: 16, role_id: 4, expiration_date: 10.years.since) # basico
UserRole.create(user_id: 17, role_id: 2, expiration_date: 10.years.since) # gestor
UserRole.create(user_id: 18, role_id: 3, expiration_date: 10.years.since) # operacional
UserRole.create(user_id: 19, role_id: 2, expiration_date: 10.years.since) # gestor
UserRole.create(user_id: 20, role_id: 3, expiration_date: 10.years.since) # operacional