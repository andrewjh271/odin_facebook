class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :about
  before_action :configure_permitted_parameters, if: :devise_controller?

  def about
    render 'shared/about'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
