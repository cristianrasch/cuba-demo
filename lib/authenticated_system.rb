module AuthenticatedSystem
  def current_user
    @current_user ||= session["email"] ? User.find_by_email(session["email"]) : nil
  end

  def logged_in?
    !! current_user
  end
  
  def login_required
    res.redirect "/login" unless logged_in?
  end
end
