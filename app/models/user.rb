class User < ActiveRecord::Base
  BASICO = "Basico"
  OPERACIONAL = "Operacional"
  GESTOR = "Gestor"
  ADMINISTRADOR = "Administrador"

  PROFILES = [BASICO, OPERACIONAL, GESTOR, ADMINISTRADOR]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" },
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

  validates_inclusion_of :profile, :in => PROFILES

  has_many :geo_entities
  has_many :team_members
  has_many :teams, through: :team_members

  # concatena o primeiro com o ultimo para as labels e afins
  def full_name
    "#{first_name} #{last_name}"
  end
end
