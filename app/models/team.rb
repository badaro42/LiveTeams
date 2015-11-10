class Team < ActiveRecord::Base
  has_paper_trail

  has_many :team_members
  has_many :users, through: :team_members

  belongs_to :user

  attr_accessor :is_leader
  accepts_nested_attributes_for :team_members
  accepts_nested_attributes_for :users

  validates :name, presence: true

  def users=(users)
    users.reject(&:blank?)
  end
end
