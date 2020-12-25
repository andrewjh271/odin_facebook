class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def posts
    @user = User.find(params[:user_id])
    @posts = Post.where(author: @user)
                 .includes(:likes, comments: [:comments])
                 .order(created_at: :desc)
  end

  def photos
    @user = User.find(params[:user_id])
    @photos = @user.photos
  end

  def likes
    user = User.find(params[:user_id])
    @likes = user.likes.where(likable_type: 'Post').includes(:likable)
  end

  def friends
    if params[:user_id]
      @friends = User.find(params[:user_id]).friends.with_attached_avatar.order(:name)
    else
      @friends = current_user.friends.with_attached_avatar.order(:name)
    end
  end

  def friend_requests
    @invitations = current_user.friend_invitations.includes(requester: { avatar_attachment: :blob} )
  end

  def find_friends
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    current_user.update(profile_params)
    redirect_to root_url
  end

  private

  def profile_params
    params.require(:user).permit(:avatar, photos: [])
  end
end