module AppsHelper
  def has_right(the_app)
    User.current.admin? or the_app.user_id == User.current.id
  end
end
