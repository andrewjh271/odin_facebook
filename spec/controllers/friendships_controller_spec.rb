require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do

  describe 'DELETE #destroy' do
    let(:friendship) { FactoryBot.create(:friendship) }
    context 'with authorized user' do
      before(:each) { sign_in friendship.friend_a }

      it 'destroys the requested friendship' do
        expect {
          delete :destroy, params: { id: friendship.to_param }
        }.to change(Friendship, :count).by(-1)
      end

      it 'redirects to current user\'s profile' do
        delete :destroy, params: { id: friendship.to_param }
        expect(response).to redirect_to(user_url(friendship.friend_a))
        expect(flash[:notice]).to eq('Friendship was successfully deleted.')
      end
    end

    context 'with unauthorized user' do
      before(:each) { sign_in FactoryBot.create(:user) }
      it 'redirects to root if user is not authorized' do
        delete :destroy, params: { id: friendship.to_param }
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to eq('You are not authorized to delete this friendship!')
      end
    end
  end
end