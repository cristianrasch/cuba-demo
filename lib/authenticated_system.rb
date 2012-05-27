module AuthenticatedSystem
  def current_user
    @current_user ||= _session("email") ? User.find_by_email(_session("email")) : nil
  end

  def logged_in?
    !! current_user
  end
  
  def login_required
    redirect_to("/login") unless logged_in?
  end
  
private

  def _session(key)
    session[key]
  end
  
  def redirect_to(path)
    res.redirect path
  end
end
