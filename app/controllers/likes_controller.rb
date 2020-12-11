class LikesController < ApplicationController
  def create
    Like.create(like_params) if params[:like][:user_id].to_i == current_user.id
    redirect_to referer_url_with_anchor(Post.find(params[:like][:post_id]))
  end

  def destroy
    like = Like.find(params[:id])
    post = like.post
    like.destroy if like.user == current_user
    redirect_to referer_url_with_anchor(post)
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :post_id)
  end

  def referer_url_with_anchor(post)
    case request.referer
    when /posts/ then posts_url(anchor: post.id)
    when /profile/ then profile_url(anchor: post.id)
    else user_url(post.author, anchor: post.id)
    end
  end
end