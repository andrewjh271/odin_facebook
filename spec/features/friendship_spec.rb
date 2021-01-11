require 'rails_helper'
require 'feature_helper'

RSpec.configure do |c|
  c.include FeatureHelper
end

feature 'friend requests' do
  given(:user) { FactoryBot.create(:user, occupation: 'Lost Pet Detective') }
  given(:user2) { FactoryBot.create(:user) }

  background(:each) { login user }

  scenario 'accepting a friend request creates a friendship' do
    FriendRequest.create(recipient: user, requester: user2)
    visit friends_requests_path
    find('.confirm-request').click
    visit friends_path
    within("div.friends-container") do
      expect(page).to have_content(user2.name)
    end
  end

  scenario 'accepting a friend request removes the request' do
    FriendRequest.create(recipient: user, requester: user2)
    visit friends_requests_path
    find('.confirm-request').click
    within("div.friends-container") do
      expect(page).not_to have_content(user2.name)
    end
  end

  scenario 'declining a friend request removes the request' do
    FriendRequest.create(recipient: user, requester: user2)
    visit friends_requests_path
    find('.delete-request').click
    within("div.friends-container") do
      expect(page).not_to have_content(user2.name)
    end
  end

  scenario 'friend request count in header and profile sidebar' do
    3.times { FriendRequest.create(recipient: user, requester: FactoryBot.create(:user)) }
    visit root_path
    within("div#profile_sidebar") do
      expect(page).to have_content('3')
    end
    within("header") do
      expect(page).to have_content('3')
    end
    FriendRequest.last.destroy
    visit root_path
    within("div#profile_sidebar") do
      expect(page).not_to have_content('3')
      expect(page).to have_content('2')
    end
    within("header") do
      expect(page).not_to have_content('3')
      expect(page).to have_content('2')
    end
  end
end