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

# USERS first_name:string last_name:string email:string course:string about_me:text

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
    r=Random.rand(10)
    r2=Random.rand(12)
    t = User.create(
        first_name: first_names[(r+i)%first_names.length],
        last_name: last_names[(r2+i)%last_names.length],
        email: first_names[(r+i)%first_names.length]+''+i.to_s+'@mail.com',
        avatar: File.open(Rails.root + "app/assets/teste.png"),
        password: 'qweqweqwe',
        password_confirmation: 'qweqweqwe'
    )
  end

  # puts t.errors.messages
  # puts "Adicionado o user com id=#{i}, name=#{t.first_name}, mail=#{t.email}"
end


puts 'Adding 10 Teams'

0.upto(9) do |i|
  Team.create(
      name: team_names[i], latlon: "Point("+i.to_s+" "+i.to_s+")"
  )
end


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