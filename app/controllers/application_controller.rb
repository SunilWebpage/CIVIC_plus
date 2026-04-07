class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?, :show_navbar?, :admin?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    redirect_to login_path, alert: "Please log in first."
  end

  def admin?
    current_user&.admin?
  end

  def require_admin
    return if admin?

    redirect_to root_path, alert: "Admin access only."
  end

  def show_navbar?
    !controller_name.in?(%w[users sessions])
  end
end
