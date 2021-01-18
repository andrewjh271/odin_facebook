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
    # anchor cannot be directly added to request.referer
    anchor = "#{likable.class.to_s.downcase}-#{likable.id}"
    case request.referer
    when /users\/\d+\/posts/ then user_posts_url(likable.author, anchor: anchor)
    when /likes/ then request.referer
    when /users\/\d/ then user_url(likable.author, anchor: anchor)
    when /posts\/\d/ then post_url(likable.get_post_or_photo_id, anchor: anchor)
    when /posts/ then posts_url(anchor: anchor)
    when /search\?query=(?<query>\w+)/ then "#{search_url}?query=#{Regexp.last_match(:query)}##{anchor}"
    else root_url(anchor: anchor)
    end
  end
end