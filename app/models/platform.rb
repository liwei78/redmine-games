class Platform < ActiveRecord::Base
  
  set_table_name "games_platforms"

  acts_as_list
  validates_presence_of :name

  has_many :app_platforms
  has_many :apps, :through => :app_platforms
  
end
