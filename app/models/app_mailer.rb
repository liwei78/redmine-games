class AppMailer < ActionMailer::Base
  layout 'mailer'
  helper :application

  include ActionController::UrlWriter
  include Redmine::I18n

  def new_app(app, pid)
    recipients User.active.find(:all, :conditions => {:admin => true}).collect { |u| u.mail }.compact
    subject "APP:" + app.title
    body :app => app,
      :app_url => url_for(:host => "www.cocos2d-x.org", :controller => 'apps', :action => 'show', :id => app.id, :project_id => pid)
    render_multipart('new_app', body)
  end

  def render_multipart(method_name, body)
    if Setting.plain_text_mail?
      content_type "text/plain"
      body render(:file => "#{method_name}.text.plain.rhtml", :body => body, :layout => 'mailer.text.plain.erb')
    else
      content_type "multipart/alternative"
      part :content_type => "text/plain", :body => render(:file => "#{method_name}.text.plain.rhtml", :body => body, :layout => 'mailer.text.plain.erb')
      part :content_type => "text/html", :body => render_message("#{method_name}.text.html.rhtml", body)
    end
  end
end
