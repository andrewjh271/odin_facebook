class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:about, :not_found, :internal_server, :unprocessable]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  REQUESTING_FRIENDS_IDS = [1, 7, 11, 22, 24, 29, 35, 37, 39, 45, 55, 530]
  # based on existing production database: id 530 will fail based on db:seed

  def ensure_avatar
    @user.set_avatar! unless @user.avatar.attached?
  end

  def create_friend_invitations
    REQUESTING_FRIENDS_IDS.each do |requester_id|
      friend_request = @user.friend_invitations.build(requester_id: requester_id)
      friend_request.save!
    end
  end

  def send_welcome_email
    UserMailer.with(user: @user).welcome_email.deliver_now
  end

  def send_new_sign_up_email
    UserMailer.with(user: @user, ip: request.remote_ip).new_sign_up.deliver_now
  end

  def send_odin_delete_email
    UserMailer.with(ip: request.remote_ip).odin_delete.deliver_now
  end

  def send_odin_update_email
    UserMailer.with(ip: request.remote_ip).odin_update.deliver_now
  end
end
