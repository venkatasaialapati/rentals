class ApplicationController < ActionController::Base
  before_action :ensure_admin_exists, unless: :devise_controller?
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  private

  # ✅ Fix: Ensure an admin exists but prevent unnecessary redirects
  def ensure_admin_exists
    return if User.exists?(role: 1)  # If an admin exists, skip this check
    return if request.fullpath == new_user_registration_path  # Prevent redirect loop

    redirect_to new_user_registration_path, alert: "No admin found. Please create one."
  end

  # ✅ Fix: Prevent redirect loop when already signed in
  def authenticate_user!
    if !user_signed_in?
      redirect_to new_user_session_path, alert: "You need to sign in first." unless request.fullpath == new_user_session_path
    end
  end

  def storable_location?
    request.get? && !request.xhr? && !devise_controller?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
