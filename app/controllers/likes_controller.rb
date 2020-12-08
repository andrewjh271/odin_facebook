class LikesController < ApplicationController
  def create
    if params[:like][:user_id].to_i == current_user.id
      Like.create(like_params)
    else
      # do nothing
    end
    redirect_back fallback_location: root_url
  end

  def destroy
    like = Like.find(params[:id])
    if like.user == current_user
      Like.destroy(params[:id])
    else
      # do nothing
    end
    redirect_back fallback_location: root_url
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :post_id)
  end
end