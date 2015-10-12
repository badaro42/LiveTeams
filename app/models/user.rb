class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
                    # url: '/images/users/:id/:style/:basename.:extension',
                    # path: ':rails_root/public/images/users/:id/:style/:basename.:extension'

  # validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  # validates_attachment_presence :avatar
  # validates_attachment_size :avatar, :less_than => 5.megabytes
  # validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :avatar, presence: true
  validates :email, presence: true, uniqueness: true
end
