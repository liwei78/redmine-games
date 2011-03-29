class CreateScreenshots < ActiveRecord::Migration
  def self.up
    create_table :games_screenshots do |t|
      t.integer  :app_id
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size
      t.datetime :file_updated_at
    end
  end

  def self.down
    drop_table :games_screenshots
  end
end
