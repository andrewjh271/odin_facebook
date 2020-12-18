require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'POST #create' do
    before(:each) { sign_in user }

    it 'creates a new Like for a Post' do
      likable = FactoryBot.create(:post)
      expect {
        post :create, params: { like: { likable_id: likable.id, likable_type: 'Post', user_id: user.id } }
      }.to change(Like, :count).by(1)
      expect(Like.last.likable).to eq(likable)
    end

    it 'creates a new Like for a Comment' do
      likable = FactoryBot.create(:comment)
      expect {
        post :create, params: { like: { likable_id: likable.id, likable_type: 'Comment', user_id: user.id } }
      }.to change(Like, :count).by(1)
      expect(Like.last.likable).to eq(likable)
    end

    it 'does not allow duplicate likes' do
      likable = FactoryBot.create(:post)
      post :create, params: { like: { likable_id: likable.id, likable_type: 'Post', user_id: user.id } }
      expect {
        post :create, params: { like: { likable_id: likable.id, likable_type: 'Post', user_id: user.id } }
      }.to change(Like, :count).by(0)
    end
  end

  describe 'DELETE #destroy' do
    let(:like) { FactoryBot.create(:like) }

    context 'with authorized user' do
      it 'destroys the requested like' do
        sign_in like.user
        expect {
          delete :destroy, params: { id: like.id }
        }.to change(Like, :count).by(-1)
      end
    end

    context 'with unauthorized user' do

      it 'does not destroy like if user is not authorized' do
        sign_in user
        like
        expect {
          delete :destroy, params: { id: like.id }
        }.to change(Like, :count).by(0)
      end

      it 'redirects to referer URL or root, with liked post or photo anchored' do
        sign_in user
        delete :destroy, params: { id: like.id }
        expect(response).to redirect_to("#{root_url}##{like.likable.class.to_s.downcase}-#{like.likable.get_post_or_photo_id}")
      end
    end
  end
end