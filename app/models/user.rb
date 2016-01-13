class User < ActiveRecord::Base
  BASIC_PROFILES = [Role::BASICO, Role::OPERACIONAL, Role::GESTOR, Role::ADMINISTRADOR]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # usar # em vez de > para for�ar as imagens a terem a resolu��o pretendida
  has_attached_file :avatar, styles: {medium: "300x300#", small: "175x175#", thumb: "75x75#"},
                    default_url: ActionController::Base.helpers.asset_path('teste.png'),
                    url: '/images/users/:id/:style/:basename.:extension',
                    path: ':rails_root/public/images/users/:id/:style/:basename.:extension'

  # Validate content type
  validates_attachment_content_type :avatar, content_type: /\Aimage/
  # Validate filename
  validates_attachment_file_name :avatar, matches: [/png\Z/, /jpe?g\Z/]

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :avatar, presence: true
  validates :profile, presence: true
  validates :email, presence: true, uniqueness: true

  validates_inclusion_of :profile, :in => BASIC_PROFILES

  has_many :geo_entities
  has_many :team_members
  has_many :teams, through: :team_members

  # verifica a data limite aquando da chamada 'user.roles'
  # ou seja, apenas apresenta os papéis do utilizador que ainda nao tenham expirado
  has_many :user_roles, -> { where "expiration_date > ?", Time.current }
  has_many :roles, through: :user_roles

  has_many :permissions, through: :roles


  # concatena o primeiro com o ultimo para as labels e afins
  def full_name
    "#{first_name} #{last_name}"
  end

  # verifica se o perfil do utilizador é igual ao passado em parametro
  def is?(requested_profile)
    self.profile == requested_profile.to_s
  end
end
