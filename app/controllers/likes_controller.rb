class LikesController < ApplicationController
  def create
    like = Like.create(like_params) if params[:like][:user_id].to_i == current_user.id
    if like
      redirect_to referer_url_with_anchor(like.likable)
    else
      redirect_back fallback_location: root_url
    end
  end

  def destroy
    like = Like.find(params[:id])
    likable = like.likable
    like.destroy if like.user == current_user
    redirect_to referer_url_with_anchor(likable)
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :likable_id, :likable_type)
  end

  def referer_url_with_anchor(likable)
    anchor = "#{likable.class.to_s.downcase}-#{likable.id}"
    case request.referer
    when /posts\/\d/ then post_url(likable.get_post_or_photo_id)
    when /posts/ then posts_url(anchor: anchor)
    # when /photos\/\d/ then post_url(likable.id)
    when /users\/\d+\/posts/ then user_posts_url(likable.author, anchor: anchor)
    # when /users\/\d+\/photos/ then user_photos_url(likable.something, anchor: anchor)
    when /likes/ then user_likes_url(current_user.id)
    else root_url(anchor: anchor)
    end
  end
end