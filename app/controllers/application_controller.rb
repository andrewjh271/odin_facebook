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

  private

  REQUESTING_FRIENDS_IDS = [1, 5, 8, 24, 25, 26, 31, 39, 48, 50]

  def ensure_avatar
    @user.set_avatar! unless @user.avatar.attached?
  end

  def create_friend_invitations
    REQUESTING_FRIENDS_IDS.each do |requester_id|
      friend_request = @user.friend_invitations.build(requester_id: requester_id)
      friend_request.save
    end
  end
end
