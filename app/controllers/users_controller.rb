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
    user = User.find(params[:user_id])
    @posts = Post.where(author: user)
  end

  def photos
    user = User.find(params[:user_id])
    # @photos = Photo.where(author: user)
  end

  def likes
    user = User.find(params[:user_id])
    @likes = user.likes.where(likable_type: 'Post').includes(:likable)
  end

  def friends
    if params[:user_id]
      @friends = User.find(params[:user_id]).friends
    else
      @friends = current_user.friends
    end
  end

  def friend_requests
  end

  def find_friends
  end
end