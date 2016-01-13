# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

team_names = ['PSP Feijo', 'Proteccao Civil Almada', 'Bombeiros Cacilhas', 'Grupo de populares', 'PSP Laranjeiro',
              'Fuzileiros', 'Marinha', 'Forca Aerea', 'Administradores', 'Policia Maritima']

subject_classes = ["user", "team", "team_member", "geo_entity"]
subject_actions = ["create", "read", "update", "destroy"]

# USER first_name:string last_name:string email:string password:string avatar:imagem
puts 'Adding 20 Users'

# id 1
User.create(first_name: 'Admin', last_name: 'Sistema', email: 'admin@mail.com', password: 'adminadmin',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_1.jpg"), password_confirmation: 'adminadmin',
            profile: User::ADMINISTRADOR, phone_number: '212111111',
            latlon: 'POINT(-9.160860925912857 38.62768769514654)') # Vale de Milha�os
# id 2
User.create(first_name: 'José', last_name: 'Sócrates', email: 'jose_socrates@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111112',
            latlon: 'POINT(-9.203015863895416 38.661109791229485)') # FCT-UNL DI
# id 3
User.create(first_name: 'Joana', last_name: 'Marques', email: 'joana_marques@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_1.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111113',
            latlon: 'POINT(-9.147389531135559 38.6874694378102)') # Metro Cacilhas
# id 4
User.create(first_name: 'Renato', last_name: 'Alexandre', email: 'renato_alexandre@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_1.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::OPERACIONAL, phone_number: '212111114',
            latlon: 'POINT(-9.160088449716568 38.65548397079349)') # Campos T�nis Feij�
# id 5
User.create(first_name: 'Filipa', last_name: 'Dias', email: 'filipa_dias@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_4.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::OPERACIONAL, phone_number: '212111115',
            latlon: 'POINT(-9.23403024673462 38.64389162826271)') # Costa da Caparica
# id 6
User.create(first_name: 'Miguel', last_name: 'Alberto', email: 'miguel_alberto@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_4.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::OPERACIONAL, phone_number: '212111116',
            latlon: 'POINT(-9.171277284622192 38.678508079563805)') # Cristo Rei
# id 7
User.create(first_name: 'Bruno', last_name: 'Aleixo', email: 'bruno_aleixo@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_5.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::OPERACIONAL, phone_number: '212111117',
            latlon: 'POINT(-9.136432707309723 38.70748187656837)') # Pra�a do Com�rcio
# id 8
User.create(first_name: 'Antónia', last_name: 'Coelho', email: 'antonia_coelho@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111118',
            latlon: 'POINT(-9.094029664993286 38.76843921624117)') # Pavilh�o Atl�ntico
# id 9
User.create(first_name: 'Rafael', last_name: 'Bizarra', email: 'rafael_bizarra@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::ADMINISTRADOR, phone_number: '212111119',
            latlon: 'POINT(-9.213436245918274 38.42022552818708)') # Cabo Espichel
# id 10
User.create(first_name: 'Roberta', last_name: 'Frangueira', email: 'roberta_frangueira@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_3.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::OPERACIONAL, phone_number: '212111120',
            latlon: 'POINT(-8.903088569641113 38.49027879470561)') # Pen�nsula de Tr�ia
# id 11
User.create(first_name: 'Maria', last_name: 'Alves', email: 'maria_alves@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_5.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111121',
            latlon: 'POINT(-9.22276496887207 38.6275996886131)')
# id 12
User.create(first_name: 'Álvaro', last_name: 'Branco', email: 'alvaro_branco@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_3.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111122',
            latlon: 'POINT(-9.081315994262695 38.626258623311166)')
# id 13
User.create(first_name: 'Patrícia', last_name: 'Silva', email: 'patricia_silva@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_3.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111123',
            latlon: 'POINT(-9.095392227172852 38.5937971957727)')
# id 14
User.create(first_name: 'Valter', last_name: 'Costa', email: 'valter_costa@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_5.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111124',
            latlon: 'POINT(-9.323358535766602 38.680417696714684)')
# id 15
User.create(first_name: 'Diogo', last_name: 'Fonseca', email: 'diogo_fonseca@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_1.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::ADMINISTRADOR, phone_number: '212111125',
            latlon: 'POINT(-9.20628547668457 38.69756846453178)')
# id 16
User.create(first_name: 'Rita', last_name: 'Nobre', email: 'rita_nobre@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_1.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::BASICO, phone_number: '212111126',
            latlon: 'POINT(-9.420175552368164 38.69408504756833)')
# id 17
User.create(first_name: 'António', last_name: 'Esteves', email: 'antonio_esteves@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_4.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111127',
            latlon: 'POINT(-9.381723403930664 38.69676461413586)')
# id 18
User.create(first_name: 'Filipe', last_name: 'Jesus', email: 'filipe_jesus@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_male_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::OPERACIONAL, phone_number: '212111128',
            latlon: 'POINT(-9.298982620239258 38.659777730712534)')
# id 19
User.create(first_name: 'Ana', last_name: 'Henrique', email: 'ana_henrique@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_4.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::GESTOR, phone_number: '212111129',
            latlon: 'POINT(-9.257440567016602 38.662458581979436)')
# id 20
User.create(first_name: 'Inês', last_name: 'Rodrigues', email: 'ines_rodrigues@mail.com', password: 'qweqweqwe',
            avatar: File.open(Rails.root + "app/assets/images/profile_pic_female_2.jpg"), password_confirmation: 'qweqweqwe',
            profile: User::OPERACIONAL, phone_number: '212111130',
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
TeamMember.create(team_id: 1, user_id: 1, is_leader: true)
TeamMember.create(team_id: 1, user_id: 2, is_leader: false)
TeamMember.create(team_id: 2, user_id: 3, is_leader: true)
TeamMember.create(team_id: 3, user_id: 4, is_leader: false)
TeamMember.create(team_id: 3, user_id: 6, is_leader: true)
TeamMember.create(team_id: 4, user_id: 7, is_leader: true)
TeamMember.create(team_id: 5, user_id: 8, is_leader: true)
TeamMember.create(team_id: 6, user_id: 9, is_leader: true)
TeamMember.create(team_id: 6, user_id: 10, is_leader: false)
TeamMember.create(team_id: 6, user_id: 11, is_leader: false)
TeamMember.create(team_id: 7, user_id: 15, is_leader: true)
TeamMember.create(team_id: 7, user_id: 17, is_leader: false)
TeamMember.create(team_id: 8, user_id: 18, is_leader: true)
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
Team.update(8, location_user_id: 18, latlon: User.find(18).latlon)
Team.update(9, location_user_id: 19, latlon: User.find(19).latlon)
Team.update(10, location_user_id: 20, latlon: User.find(20).latlon)


# TEAM_MEMBER team_id:integer user_id:integer is_leader:boolean
puts 'Adding Geographic Entities'
GeoEntity.create(name: "Entrada para o Arsenal do Alfeite", user_id: 2, entity_type: "marker", radius: 0,
                 latlon: "POINT(-9.154230505228043 38.658546181023475)",
                 description: "Tambem conhecida por Portao Verde",
                 team_ids: [5,7]) # Port�o Verde

GeoEntity.create(name: "Belo caminho por Portugal", user_id: 1, entity_type: "polyline", radius: 0,
                 latlon: "LINESTRING(-9.166889190673828 38.64583568648869, -8.715591430664062 39.257778150283336, " +
                     "-8.442392349243164 40.272715386988686, -8.231935501098633 40.305189027180226, " +
                     "-7.912387847900391 40.65095033081072, -7.702789306640625 41.306697618181886, " +
                     "-7.412896156311036 41.34846396411108)",
                 description: "Demora-se um bocado a chegar, mas a recompensa vale a pena",
                 team_ids: [2,3,6,8]) # Lisboa - Sta. Eug�nia

GeoEntity.create(name: "Base Naval de Lisboa - Arsenal do Alfeite", user_id: 3, entity_type: "polygon", radius: 0,
                 latlon: "POLYGON((-9.157555103302002 38.66761893813652, -9.144165515899658 38.67324799343888, " +
                     "-9.128201007843018 38.65749892823337, -9.13764238357544 38.64811486000121, " +
                     "-9.145710468292236 38.6563594998049, -9.157555103302002 38.66761893813652))",
                 description: "Zona bem grande e com alguns navios porreiros",
                 team_ids: [1,4]) # �rea do Arsenal do Alfeite

# PERMISSION subject_class:string subject_action:string
puts 'Adding Permissions'
Permission.create(subject_class: subject_classes[0], subject_action: subject_actions[0]) #1: user create
Permission.create(subject_class: subject_classes[0], subject_action: subject_actions[1]) #2: user read
Permission.create(subject_class: subject_classes[0], subject_action: subject_actions[2]) #3: user update
Permission.create(subject_class: subject_classes[0], subject_action: subject_actions[3]) #4: user delete

Permission.create(subject_class: subject_classes[1], subject_action: subject_actions[0]) #5: team create
Permission.create(subject_class: subject_classes[1], subject_action: subject_actions[1]) #6: team read
Permission.create(subject_class: subject_classes[1], subject_action: subject_actions[2]) #7: team update
Permission.create(subject_class: subject_classes[1], subject_action: subject_actions[3]) #8: team destroy

Permission.create(subject_class: subject_classes[2], subject_action: subject_actions[0]) #9: team_member create
Permission.create(subject_class: subject_classes[2], subject_action: subject_actions[1]) #10: team_member read
Permission.create(subject_class: subject_classes[2], subject_action: subject_actions[2]) #11: team_member update
Permission.create(subject_class: subject_classes[2], subject_action: subject_actions[3]) #12: team_member destroy

Permission.create(subject_class: subject_classes[3], subject_action: subject_actions[0]) #13: geo_entity create
Permission.create(subject_class: subject_classes[3], subject_action: subject_actions[1]) #14: geo_entity read
Permission.create(subject_class: subject_classes[3], subject_action: subject_actions[2]) #15: geo_entity update
Permission.create(subject_class: subject_classes[3], subject_action: subject_actions[3]) #16: geo_entity destroy

# ROLE name:string permission_ids:array de strings
puts 'Adding Roles'
# TODO: PASSAR ESTES PAPEIS PARA O MODELO 'ROLE', TAL COMO ESTÃO OS OUTROS PAPEIS
Role.create(name: User::ADMINISTRADOR)
Role.create(name: User::GESTOR)
Role.create(name: User::OPERACIONAL)
Role.create(name: User::BASICO)

Role.create(name: Role::REMOVE_GEO_ENTITIES)
Role.create(name: Role::REMOVE_USERS)
Role.create(name: Role::MANAGE_TEAMS)
Role.create(name: Role::MANAGE_TEAM_MEMBERS)
Role.create(name: Role::MANAGE_TEAM_AND_TEAM_MEMBERS)

# ROLE_PERMISSION role_id:integer permission_id
puts 'Associating permissions to roles'
RolePermission.create(role_id: 1, permission_id: 2) # ADMINISTRADOR
RolePermission.create(role_id: 1, permission_id: 3)
RolePermission.create(role_id: 1, permission_id: 4)
RolePermission.create(role_id: 1, permission_id: 5)
RolePermission.create(role_id: 1, permission_id: 6)
RolePermission.create(role_id: 1, permission_id: 7)
RolePermission.create(role_id: 1, permission_id: 8)
RolePermission.create(role_id: 1, permission_id: 9)
RolePermission.create(role_id: 1, permission_id: 10)
RolePermission.create(role_id: 1, permission_id: 12)
RolePermission.create(role_id: 1, permission_id: 13)
RolePermission.create(role_id: 1, permission_id: 14)
RolePermission.create(role_id: 1, permission_id: 16)

RolePermission.create(role_id: 2, permission_id: 2) # GESTOR
RolePermission.create(role_id: 2, permission_id: 3)
RolePermission.create(role_id: 2, permission_id: 5)
RolePermission.create(role_id: 2, permission_id: 6)
RolePermission.create(role_id: 2, permission_id: 7)
RolePermission.create(role_id: 2, permission_id: 8)
RolePermission.create(role_id: 2, permission_id: 9)
RolePermission.create(role_id: 2, permission_id: 10)
RolePermission.create(role_id: 2, permission_id: 12)
RolePermission.create(role_id: 2, permission_id: 13)
RolePermission.create(role_id: 2, permission_id: 14)
RolePermission.create(role_id: 2, permission_id: 16)

RolePermission.create(role_id: 3, permission_id: 2) # OPERACIONAL
RolePermission.create(role_id: 3, permission_id: 3)
RolePermission.create(role_id: 3, permission_id: 6)
RolePermission.create(role_id: 3, permission_id: 10)
RolePermission.create(role_id: 3, permission_id: 13)
RolePermission.create(role_id: 3, permission_id: 14)

RolePermission.create(role_id: 4, permission_id: 2) # BASICO
RolePermission.create(role_id: 4, permission_id: 3)
RolePermission.create(role_id: 4, permission_id: 6)
RolePermission.create(role_id: 4, permission_id: 10)
RolePermission.create(role_id: 4, permission_id: 14)

RolePermission.create(role_id: 5, permission_id: 16) # REMOVER GEO-ENTIDADES

RolePermission.create(role_id: 6, permission_id: 4) # REMOVER UTILIZADORES

RolePermission.create(role_id: 7, permission_id: 5) # GERIR EQUIPAS
RolePermission.create(role_id: 7, permission_id: 7)
RolePermission.create(role_id: 7, permission_id: 8)

RolePermission.create(role_id: 8, permission_id: 9) # GERIR MEMBROS DE EQUIPAS
RolePermission.create(role_id: 8, permission_id: 12)

RolePermission.create(role_id: 9, permission_id: 5) # GERIR EQUIPAS E MEMBROS DE EQUIPAS
RolePermission.create(role_id: 9, permission_id: 7)
RolePermission.create(role_id: 9, permission_id: 8)
RolePermission.create(role_id: 9, permission_id: 9)
RolePermission.create(role_id: 9, permission_id: 12)

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