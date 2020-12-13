class ProfilesController < ApplicationController
  def posts
    @posts = current_user.posts
    
  end

  def photos

  end

  def likes
    @likes = current_user.likes.includes(:post)
  end
end