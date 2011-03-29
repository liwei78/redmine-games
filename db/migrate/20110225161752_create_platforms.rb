class CreatePlatforms < ActiveRecord::Migration
  def self.up
    create_table :games_platforms do |t|
      t.column  :name, :string
      t.column  :position, :integer, :default => 0
      t.string  :input_type
      t.boolean :snatch_detail, :default => false
    end
    Platform.create([
        {:name => "iOS",  :input_type => "Application ID",  :snatch_detail => true},
        {:name => "Android", :input_type => "Store url"},
        {:name => "WOPhone", :input_type => "Store url"},
        {:name => "bada",    :input_type => "Store url"},
        {:name => "Other",   :input_type => "Store url"}
      ])
  end

  def self.down
    drop_table :games_platforms
  end
end
