class PlatformsController < ApplicationController

  def new
    @platform = Platform.new(params[:platform])
    if request.post? && @platform.save
      expire_fragment("sider_platforms_list")
      flash[:notice] = l(:notice_successful_create)
      redirect_to :controller => "settings", :action => "plugin", :id => "redmine_games"
    end
  end

  def edit
    @platform = Platform.find(params[:id])
    if request.post? && @platform.update_attributes(params[:platform])
      expire_fragment("sider_platforms_list")
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller => "settings", :action => "plugin", :id => "redmine_games"
    end
  end

  def destroy
    platform = Platform.find(params[:id])
    platform.destroy
    redirect_to :controller => "settings", :action => "plugin", :id => "redmine_games"
  end

end
