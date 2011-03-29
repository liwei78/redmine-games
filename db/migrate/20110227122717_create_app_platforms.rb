class CreateAppPlatforms < ActiveRecord::Migration
  def self.up
    create_table :games_app_platforms do |t|
      t.integer :app_id
      t.integer :platform_id
      t.string  :store_url
    end
    add_index :games_app_platforms, [:app_id, :platform_id], :name => :app_id_and_platform_id
  end

  def self.down
    drop_table :games_app_platforms
  end
end
