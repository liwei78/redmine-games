class AddCountryToApps < ActiveRecord::Migration
  def self.up
    add_column :games_apps, :country, :string
  end

  def self.down
    remove_column :games_apps, :country
  end
end
