class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friend_request, except: :create

  def create
    friend_request = FriendRequest.create(requester_id: current_user.id, recipient_id: params[:recipient_id])
    if friend_request.save
      redirect_to user_url(current_user), notice: 'Friend Request sent!'
    else
      redirect_to user_url(current_user), alert: "Sorry, your request could not be completed. (#{friend_request.errors.full_messages.join(', ')}.)"
    end
  end

  def confirm
    if @friend_request.recipient == current_user
      Friendship.create(friend_a: @friend_request.requester, friend_b: @friend_request.recipient)
      @friend_request.destroy
      redirect_to user_url(current_user), notice: 'Friend Request accepted!'
    else
      flash[:alert] = 'You are not authorized to accept this friend request.'
      redirect_to root_url
    end
  end

  def delete
    if @friend_request.recipient == current_user
      @friend_request.destroy
      redirect_to user_url(current_user), notice: 'Friend Request was successfully deleted.'
    else
      flash[:alert] = 'You are not authorized to delete this friend request.'
      redirect_to root_url
    end
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end