require 'rails_helper'
require 'feature_helper'

RSpec.configure do |c|
  c.include FeatureHelper
end

feature 'user show page' do
  given(:user) { FactoryBot.create(:user, occupation: 'Lost Pet Detective') }
  given(:user2) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post, author: user) }

  background(:each) { login user }

  scenario 'shows a user\'s basic info and posts' do
    visit user_url(user)
    expect(page).to have_content(user.name)
    expect(page).to have_content('Lost Pet Detective')
  end

  scenario 'shows a user\'s posts' do
    post
    visit user_url(user)
    expect(page).to have_content(post.body)
  end

  scenario 'shows a user\'s friends' do
    Friendship.create(friend_a: user, friend_b: user2)
    visit user_url(user)
    expect(page).to have_content(user2.name)
  end

end

feature 'editing account information' do
  given(:user) { FactoryBot.create(:user) }

  background(:each) { login user }

  scenario 'renders edit user registration page' do
    visit edit_user_registration_path
    expect(page).to have_content('Edit Account')
  end

  scenario 'changes user name' do
    visit edit_user_registration_path
    fill_in 'user_name', with: 'Tennessee Williams'
    fill_in 'user_current_password', with: user.password
    click_on 'Update'
    expect(page).to have_content('Tennessee Williams')
  end
end

feature 'editing profile information' do
  given(:user) { FactoryBot.create(:user) }

  background(:each) { login user }

  scenario 'renders edit profile page' do
    visit edit_profile_path
    expect(page).to have_content('Edit Profile')
  end

  scenario 'changes user name' do
    visit edit_profile_path
    fill_in 'user_education1', with: 'University of Michigan'
    click_on 'Update Profile'
    expect(page).to have_content('University of Michigan')
  end
end

feature 'friend_request page' do
  given(:user) { FactoryBot.create(:user) }

  background(:each) { login user }

  scenario 'shows a user\'s friend requests' do
    3.times { FriendRequest.create(recipient: user, requester: FactoryBot.create(:user))}
    visit friends_requests_path
    User.last(3).pluck(:name).each do |name|
      expect(page).to have_content(name)
    end
  end
end

feature 'friends page' do
  given(:user) { FactoryBot.create(:user) }

  background(:each) { login user }

  scenario 'shows a user\'s friend requests' do
    3.times { Friendship.create(friend_a: user, friend_b: FactoryBot.create(:user))}
    visit friends_path
    User.last(3).pluck(:name).each do |name|
      expect(page).to have_content(name)
    end
  end
end