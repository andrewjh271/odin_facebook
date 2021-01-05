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
                 .order(created_at: :desc)
                 .with_attached_photo
                 .includes(:likes, :author, comments: :comments)
  end

  def photos
    @user = User.find(params[:user_id])
    @posts = @user.posts
                  .joins(:photo_attachment)
                  .order(created_at: :desc)
                  .with_attached_photo
  end

  def likes
    @user = User.find(params[:user_id])
    liked_posts_ids = Like.where(user_id: @user.id, likable_type: "Post")
                          .pluck(:likable_id)
    @posts = Post.where('id IN (?)', liked_posts_ids)
                 .with_attached_photo
                 .includes(:likes, comments: :comments, author: { avatar_attachment: :blob })
                 .order(created_at: :desc)
  end

  def friends
    if params[:user_id]
      @friends = User.find(params[:user_id])
                     .friends.with_attached_avatar
                     .order(:name)
    else
      @friends = current_user.friends
                             .with_attached_avatar
                             .order(:name)
    end
  end

  def friend_requests
    @invitations = current_user.friend_invitations
                               .includes(requester: { avatar_attachment: :blob} )
                               .order('users.name')
  end

  def find_friends
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    current_user.update(profile_params)
    redirect_to profile_url
  end

  private

  def profile_params
    params.require(:user)
          .permit(:avatar, :location, :birthday, :occupation,
                  :education1, :education2, :education3, :website)
  end
end