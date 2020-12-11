require 'rails_helper'

RSpec.describe FriendRequestsController, type: :controller do
  let(:friend_request) { FactoryBot.create(:friend_request) }

  describe 'POST #create' do
    it 'creates a new FriendRequest' do
      requester = FactoryBot.create(:user)
      recipient = FactoryBot.create(:user)
      sign_in requester
      expect {
        post :create, params: { recipient_id: recipient.id }
      }.to change(FriendRequest, :count).by(1)
      expect(FriendRequest.last.requester).to eq(requester)
      expect(FriendRequest.last.recipient).to eq(recipient)
    end
  end

  describe 'POST #confirm' do
    context 'with authorized user' do
      before(:each) { sign_in friend_request.recipient }

      it 'creates a new Friendship' do
        expect {
          post :confirm, params: { id: friend_request.to_param }
        }.to change(Friendship, :count).by(1)
        expect(Friendship.last.friend_a).to eq(friend_request.requester)
        expect(Friendship.last.friend_b).to eq(friend_request.recipient)
      end

      it 'destroys the current request' do
        expect {
          post :confirm, params: { id: friend_request.to_param }
        }.to change(FriendRequest, :count).by(-1)
      end

      it 'redirects to current user\'s profile' do
        post :confirm, params: { id: friend_request.to_param }
        expect(response).to redirect_to(user_url(friend_request.recipient))
        expect(flash[:notice]).to eq('Friend Request accepted!')
      end
    end

    context 'with unauthorized user' do
      before(:each) { sign_in FactoryBot.create(:user) }

      it 'redirects to root if user is not authorized' do
        post :confirm, params: { id: friend_request.to_param }
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to eq('You are not authorized to accept this friend request.')
      end
    end
  end

  describe 'DELETE #delete' do
    context 'with authorized user' do
      before(:each) { sign_in friend_request.recipient }

      it 'destroys the requested friendship' do
        expect {
          delete :delete, params: { id: friend_request.to_param }
        }.to change(FriendRequest, :count).by(-1)
      end

      it 'redirects to current user\'s profile' do
        delete :delete, params: { id: friend_request.to_param }
        expect(response).to redirect_to(user_url(friend_request.recipient))
        expect(flash[:notice]).to eq('Friend Request was successfully deleted.')
      end
    end

    context 'with unauthorized user' do
      before(:each) { sign_in FactoryBot.create(:user) }

      it 'redirects to root if user is not authorized' do
        delete :delete, params: { id: friend_request.to_param }
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to eq('You are not authorized to delete this friend request.')
      end
    end
  end
end