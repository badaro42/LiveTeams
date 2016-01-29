class Category < ActiveRecord::Base
  has_many :geo_entities

  def self.options_for_select
    order('id').map { |e| [e.name, e.id] }
  end
end
