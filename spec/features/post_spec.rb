require 'rails_helper'
require 'feature_helper'

RSpec.configure do |c|
  c.include FeatureHelper
end

feature 'requires authentication' do
  scenario 'Redirects to login page' do
    visit new_post_path
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end

feature 'creating a new post' do
  given(:user) { FactoryBot.create(:user) }

  background(:each) { login user }

  scenario 'Includes new post input field' do
    visit new_post_path
    expect(page).to have_field('post_body', placeholder: "What's on your mind?")
  end

  feature 'creates a post' do
    background(:each) do
      visit new_post_url
      fill_in 'post_body', with: 'Green fire is lucky.'
      click_on 'Post'
    end

    scenario 'redirects to post show page after creation' do
      expect(page).to have_content 'Green fire is lucky'
    end
  end
end

feature 'editing an existing post' do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post, author: user) }

  background(:each) { login user }

  scenario 'has an edit page' do
    visit edit_post_url(post)
    expect(page).to have_button 'Update'
  end

  scenario 'updates post and redirects to show page' do
    visit edit_post_url(post)
    fill_in 'post_body', with: 'Green fire is lucky.'
    click_on 'Update'
    expect(page).to have_content 'Green fire is lucky'
    expect(page).not_to have_content post.body
  end

  scenario 'does not allow edit for user who is not author' do
    visit edit_post_url(FactoryBot.create(:post))
    expect(page).to have_content('You are not authorized to edit this post!')
  end
end

feature 'deleting a post' do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post, author: user) }

  background(:each) { login user }
  
  scenario 'deletes post and redirects to index' do
    visit post_url(post)
    
    click_on 'Delete'
    expect(page).not_to have_content post.body
  end
end

feature 'root_url (posts#index)' do
  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given(:post1) { FactoryBot.create(:post, author: user1) }
  given(:post2) { FactoryBot.create(:post, author: user2, body: 'A unique body!') }

  background(:each) { login user1 }

  scenario 'shows all the posts for logged in user and their friends' do
    post1
    post2
    Friendship.create(friend_a: user1, friend_b: user2)
    visit posts_url
    expect(page).to have_content post1.body
    expect(page).to have_content post2.body
    expect(page).to have_content 'less than a minute ago'
  end

  scenario 'doesn\'t show posts by non friends' do
    post1
    post2
    visit posts_url
    expect(page).to have_content post1.body
    expect(page).not_to have_content post2.body
  end
end