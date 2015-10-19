class Team < ActiveRecord::Base
  has_many :team_members
  has_many :users, through: :team_members

  attr_accessor :is_leader
  accepts_nested_attributes_for :team_members
  accepts_nested_attributes_for :users

  def users=(users)
    users.reject(&:blank?)
  end
end
