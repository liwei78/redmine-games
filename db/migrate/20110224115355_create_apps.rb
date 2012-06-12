class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :games_apps do |t|
      t.integer  :user_id
      t.column   :title, :string
      # t.column   :store_url, :string
      t.column   :desc, :text
      # t.column   :app_id, :string
      t.column   :im, :string
      t.column   :website, :string
      t.column   :miniblog, :string
      t.column   :phone, :string
      t.column   :author, :string
      t.column   :address, :string
      t.column   :zip_code, :string
      t.column   :pass, :boolean, :default => false
      t.column   :top, :boolean, :default => false
      t.string   :icon_file_name
      t.string   :icon_content_type
      t.integer  :icon_file_size
      t.datetime :icon_updated_at
      t.integer  :icon_style, :default => 0
      t.string   :country, :default => "en"
      t.timestamps
    end
  end

  def self.down
    drop_table :games_apps
  end
end
