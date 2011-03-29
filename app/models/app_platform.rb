class AppPlatform < ActiveRecord::Base
  set_table_name "games_app_platforms"
  belongs_to :app
  belongs_to :platform
end
