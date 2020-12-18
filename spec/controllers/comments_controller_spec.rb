require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:comment) { FactoryBot.create(:comment, author: user) }
  let(:commentable) { FactoryBot.create(:post) }
  before(:each) { sign_in user }

  describe 'GET #new' do
    it 'renders post/show form' do
      get :new, params: { post_id: commentable.id }
      expect(response).to render_template('posts/show')
    end
  end

  describe 'POST #create' do
    it 'creates a new Comment' do
      expect {
        post :create, params: { comment: { commentable_id: commentable.id, commentable_type: 'Post', body: commentable.body } }
      }.to change(Comment, :count).by(1)
      expect(Comment.last.commentable).to eq(commentable)
    end
  end

  describe 'GET #edit' do
    it 'renders post/show form' do
      get :new, params: { post_id: commentable.id }
      expect(response).to render_template('posts/show')
    end
  end

  describe 'PATCH #update' do
    it 'updates an existing Comment' do
      comment
      expect {
        put :update, params: { id: comment.id, comment: { body: 'Hello' } }
      }.to change(Comment, :count).by(0)
      comment.reload
      expect(comment.body).to eq('Hello')
    end
  end

  describe 'GET #new_reply' do
    it 'renders post/show form' do
      get :new_reply, params: { comment_id: comment.id }
      expect(response).to render_template('posts/show')
    end
  end

  describe 'DELETE #destroy' do
    let(:comment) { FactoryBot.create(:comment) }

    it 'destroys the requested like' do
      sign_in comment.author
      expect {
        delete :destroy, params: { id: comment.id }
      }.to change(Comment, :count).by(-1)
    end

    it 'redirects to comment\'s parent url' do
      sign_in comment.author
      delete :destroy, params: { id: comment.id }
      expect(response).to redirect_to(post_url(comment.get_post_or_photo_id))
    end
  end
end