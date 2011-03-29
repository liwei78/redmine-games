class AppsController < ApplicationController
  unloadable
  before_filter :find_project, :authorize
  
  def index
    @recommends = App.recommends(12)
    @updateds = App.last_updated(48)
  end

  def all
    conditions = ""
    case params[:type]
    when nil
    when "recommend"
      conditions = ["top = ?", true]
    end
    case params[:p]
    when nil
      @apps = App.paginate(
      :conditions => conditions,
      :page       => params[:page],
      :per_page   => 50,
      :order      => "updated_at desc")
    else
      platform = Platform.find_by_id(params[:p])
      @apps = platform.apps.paginate(
      :conditions => conditions,
      :page       => params[:page],
      :per_page   => 50,
      :order      => "updated_at desc")
    end
    
  end
  
  def show
    @app = App.find(params[:id])
    @screenshots = @app.screenshots
    @user = User.find_by_id(@app.user_id)
  end
  
  def new
    @app = App.new
  end
  
  def create
    @app = App.new(params[:app])
    @app.user_id = User.current.id
    if @app.save
      if params[:manual_input] == "true"
        pictures = params[:file][:data] unless params[:file].nil?
        pictures.each do |pic|
          Screenshot.create(:file => pic, :app_id => @app.id)
        end unless params[:file].nil?
      end

      platforms = params[:platforms]
      go_snatch, app_id = @app.update_platforms(platforms)

      AppMailer.deliver_new_app(@app, @project.id)

      if params[:manual_input] != "true" and go_snatch
        redirect_to :action => 'snatching', :id => @app.id, :project_id => @project, :app_id => app_id
      else
        flash[:notice] = l(:notice_successful_create)
        redirect_to :action => 'show', :id => @app.id, :project_id => @project
      end
      
    else
      render :action => 'new'
    end
  end
  
  def edit
    @app = App.find(params[:id])
    check_right(@app)
  end
  
  def update
    @app = App.find(params[:id])
    check_right(@app)
    if @app.update_attributes(params[:app])

      expire_fragment("app_cache_#{@app.id}")
      
      if params[:manual_input] == "true"
        pictures = params[:file][:data] unless params[:file].nil?
        pictures.each do |pic|
          Screenshot.create(:file => pic, :app_id => @app.id)
        end unless params[:file].nil?
      end

      platforms = params[:platforms]
      go_snatch, app_id = @app.update_platforms(platforms)

      if params[:manual_input] != "true" and go_snatch
        redirect_to :action => 'snatching', :id => @app.id, :project_id => @project, :app_id => app_id
      else
        flash[:notice] = l(:notice_successful_update)
        redirect_to :action => 'show', :id => @app.id, :project_id => @project
      end
      
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    app = App.find(params[:id])
    check_right(app)
    app.destroy if app
    flash[:notice] = l(:notice_successful_delete)
    redirect_to :action => 'index', :project_id => @project
  end

  def recommend
    app = App.find(params[:id])
    check_right(app)
    if app
      if app.top?
        app.update_attribute(:top, false)
      else
        app.update_attribute(:top, true)
      end
    end
    flash[:notice] = l(:notice_successful_update)
    redirect_to :action => 'show', :id => app.id, :project_id => @project
  end

  def delete_pic
    app = App.find(params[:id])
    check_right(app)
    pic = app.screenshots.find(params[:pid])
    pic.destroy if pic
    redirect_to :action => 'edit', :id => app.id, :project_id => @project
  end

  def snatching
    @app = App.find(params[:id])
  end

  def doing
    @app = App.find(params[:id])
    begin
      AppSnatcher.snatch_detail(@app, params[:app_id])
      msg = "SUCCESS: <a href='/projects/#{@project.id}/apps/#{@app.id}'>#{l(:view_it)}</a>"
    rescue Exception => e
      msg = "ERROR: " + e.message.to_s
    end
    respond_to do |format|
      format.js {render :update do |page|
          page.replace_html "snatch_notice", msg
        end}
    end
  end


  private

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def check_right(the_app)
    if !User.current.admin? and the_app.user_id != User.current.id
      msg = []
      if !User.current.admin?
        msg << l(:notice_not_admin)
      end
      if the_app.user_id != User.current.id
        msg << l(:notice_not_onwer)
      end
      render_403(:message => msg.join(' '))
    end
  end
end
