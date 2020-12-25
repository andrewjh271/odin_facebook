class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship
  before_action :require_friend!

  def destroy
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: user_url(current_user), notice: 'Friendship was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_friendship
    @friendship = Friendship.search(params[:friend_a_id].to_i, params[:friend_b_id].to_i)
  end

  def require_friend!
    unless [@friendship.friend_a, @friendship.friend_b].include?(current_user)
      flash[:alert] = 'You are not authorized to delete this friendship!'
      redirect_to root_url
    end
  end
end