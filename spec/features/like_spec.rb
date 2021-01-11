require 'rails_helper'
require 'feature_helper'

RSpec.configure do |c|
  c.include FeatureHelper
end

feature 'toggles likes' do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post) }

  background(:each) { login user }

  scenario 'shows count for post\'s number of likes' do
    # start count with 1 so that Comment's count of 0 doesn't interfere
    Like.create(likable: post, user: FactoryBot.create(:user))
    visit post_url(post)
    expect(page).to have_content('1')
    find('.hidden-button').click # Easiest way to target Like button
    expect(page).to have_content('2')
    expect(page).not_to have_content('1')
    find('.hidden-button').click
    expect(page).to have_content('1')
  end

  scenario 'thumbs up icon adds "liked" class when post has been liked by user' do
    visit post_url(post)
    expect(page).not_to have_css('.liked')
    find('.hidden-button').click
    expect(page).to have_css('.liked')
    find('.hidden-button').click
    expect(page).not_to have_css('.liked')
  end
end