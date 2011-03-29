require 'redmine'

Redmine::Plugin.register :redmine_games do
  name 'Redmine Games plugin'
  author 'Riquel Li'
  description 'This is a plugin for Redmine to upload your app games'
  version '0.0.1'
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