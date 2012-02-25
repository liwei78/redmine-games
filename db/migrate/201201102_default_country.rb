class DefaultCountry < ActiveRecord::Migration
  def self.up
    App.update_all(:country => "en")
  end

  def self.down
    
  end
end
