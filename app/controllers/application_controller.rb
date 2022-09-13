class ApplicationController < ActionController::Base
  private

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      redirect_to new_session_url, alert: "Please sign in to view this page!"
    end
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def current_user?(user)
    @user == current_user
  end

  helper_method :current_user?

  def require_admin
    unless current_user_admin?
      redirect_to root_url, alert: "You must be an admin to view this page!"
    end
  end

  def current_user_admin?
    current_user&.admin?
  end

  helper_method :current_user_admin?

  def profile_image(user, size=80)
    url = "https://secure.gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"
    image_tag(url, alt: user.name)
  end

  helper_method :profile_image
end
