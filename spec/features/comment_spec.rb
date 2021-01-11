require 'rails_helper'
require 'feature_helper'

RSpec.configure do |c|
  c.include FeatureHelper
end

feature 'creates a comment' do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post) }
  given(:comment) { FactoryBot.create(:comment, commentable: post) }
  given(:reply) { FactoryBot.create(:comment, commentable: comment) }

  background(:each) { login user }

  scenario 'creates a comment on a post' do
    visit post_url(post)
    fill_in 'comment_body', with: 'Green fire is lucky.'
    click_button 'Comment'
    expect(page).to have_content('Green fire is lucky.')
  end

  scenario 'creates a form for commenting on a comment' do
    visit post_url(comment.get_post_or_photo_id)
    click_on 'Reply'
    expect(page).to have_field('comment_body', placeholder: "Reply to #{comment.author.name}...")
  end

  scenario 'comments on a comment' do
    visit post_url(comment.get_post_or_photo_id)
    click_on 'Reply'
    within("div.comments") do
      fill_in 'comment_body', with: 'All giraffes eat leaves.'
    end
    click_button 'Reply'
    expect(page).to have_content('All giraffes eat leaves.')
  end

  scenario 'creates a form for commenting on a reply' do
    visit post_url(reply.get_post_or_photo_id)
    within("div#comment-#{reply.id}") do
      click_on 'Reply'
    end
    expect(page).to have_field('comment_body', placeholder: "Reply to #{reply.author.name}...")
  end

  scenario 'comments on a reply' do
    visit post_url(reply.get_post_or_photo_id)
    within("div#comment-#{reply.id}") do
      click_on 'Reply'
    end
    within("div.comment-reply") do
      fill_in 'comment_body', with: 'Where are the snowdens of yesteryear?'
      click_on 'Reply'
    end
    expect(page).to have_content('Where are the snowdens of yesteryear?')
  end

  scenario 'total comment count displayed' do
    visit post_url(reply.get_post_or_photo_id)
    within("div.comment-icon") do
      expect(page).to have_content('2')
    end
  end
end