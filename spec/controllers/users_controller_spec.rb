require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  before(:each) { sign_in user }

  describe 'GET #show' do
    it 'renders show page' do
      get :show, params: { id: user.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #posts' do
    it 'renders posts page' do
      get :posts, params: { user_id: user.id }
      expect(response).to render_template(:posts)
    end
  end

  describe 'GET #photos' do
    it 'renders photos page' do
      get :photos, params: { user_id: user.id }
      expect(response).to render_template(:photos)
    end
  end

  describe 'GET likes' do
    it 'renders likes page' do
      get :likes, params: { user_id: user.id }
      expect(response).to render_template(:likes)
    end
  end

  describe 'GET friends' do
    it 'renders likes page' do
      get :friends, params: { user_id: user.id }
      expect(response).to render_template(:friends)
    end

    it 'works with no id given' do
      get :friends
      expect(response).to render_template(:friends)
    end
  end

  describe 'GET friend_requests' do
    it 'renders requests page' do
      get :friend_requests
      expect(response).to render_template(:friend_requests)
    end
  end

  describe 'GET find_friends' do
    it 'renders find_friends page' do
      get :find_friends
      expect(response).to render_template(:find_friends)
    end
  end
end
