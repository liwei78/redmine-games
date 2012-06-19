# 0。0。1 snatch apps
# 0.0.2 auto snatch apps from url
# 0.1.2 snatch app from select country and app itunes url
# 0.1.3 fix screenshot div in diff country store
# 0.1.4 add "Indea" to country select
# 0.1.5 add "jiathis" code to app's view
# 0.1.6 chang 'Recommend' to 'Featured'
require 'redmine'

Redmine::Plugin.register :redmine_games do
  name 'Redmine Games plugin'
  author 'Riquel Li'
  description 'This is a plugin for Redmine to upload your app games'
  version '0.1.6'
  url 'http://railser.cn'
  author_url 'http://railser.cn/me'

  settings :default => {},
           :partial => 'platforms/manage'
  
  project_module :games do
    permission :manage_apps, {:apps => [:edit, :update, :new, :create, :destroy, :recommend, :delete_pic, :snatching, :doing]}, :require => :loggedin
    permission :view_apps, {:apps => [:index, :all, :show]}, :public => true
  end

  menu :project_menu, :apps, {:controller => "apps", :action => "index"}, :caption => "Games", :param => :project_id

end

ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:project_id/apps', :controller => "apps", :action => "index"
  map.connect 'projects/:project_id/apps/all', :controller => "apps", :action => "all"
  map.connect 'projects/:project_id/apps/:id', :controller => "apps", :action => "show"
  map.resources :apps, 
    :member => {:recommend => :post, :delete_pic => :post, :snatching => :get, :doing => :post},
    :collection => {:all => :get}
end