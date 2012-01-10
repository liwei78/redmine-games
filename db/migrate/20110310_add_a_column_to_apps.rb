class AddAColumnToApps < ActiveRecord::Migration
  def self.up
    # add_column :games_apps, :icon_style, :integer, :default => 0
  end

  def self.down
    # remove_column :games_apps, :icon_style
  end
end
