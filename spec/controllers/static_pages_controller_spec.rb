require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  before(:each) { sign_in user }

  describe 'GET #about' do
    it 'renders about page' do
      get :about, params: {}
      expect(response).to render_template('static_pages/about')
    end
  end

  describe 'GET #search' do
    it 'renders search page' do
      get :search, params: {query: 'test query'}
      expect(response).to render_template('static_pages/search')
    end
  end

  describe 'GET #odin_invincible' do
    it 'renders odin_invincible page' do
      get :odin_invincible, params: {}
      expect(response).to render_template('static_pages/odin_invincible')
    end
  end

  describe 'GET #odin_immutable' do
    it 'renders odin_immutable page' do
      get :odin_immutable, params: {}
      expect(response).to render_template('static_pages/odin_immutable')
    end
  end
end