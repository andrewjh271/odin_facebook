# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  name                   :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'associations' do
    context 'straightforward associations' do
      it { should have_many(:posts) }
      it { should have_many(:likes) }
      it { should have_many(:friend_requests) }
      it { should have_many(:requested_friends) }
      it { should have_many(:friend_invitations) }
      it { should have_many(:requesting_friends) }
      it { should have_one_attached(:avatar) }
    end

    context 'custom association methods' do
      let(:user1) { FactoryBot.create(:user) }
      let(:user2) { FactoryBot.create(:user) }
      let(:user3) { FactoryBot.create(:user) }
      let(:user4) { FactoryBot.create(:user) }

      it 'should have many friendships in either direction' do
        friendship1 = Friendship.create!(friend_a: user, friend_b: user1)
        friendship2 = Friendship.create!(friend_b: user2, friend_a: user)
        expect(user.friendships).to eq([friendship1, friendship2])
      end

      describe '#friends' do
        it 'should have many friends in either direction' do
          Friendship.create!(friend_a: user, friend_b: user1)
          Friendship.create!(friend_b: user2, friend_a: user)
          expect(user.friends).to eq([user1, user2])
        end
      end

      describe '#friends_sql' do
        it 'should return a user\'s friends' do
          Friendship.create!(friend_a: user, friend_b: user1)
          Friendship.create!(friend_b: user2, friend_a: user)
          expect(user.friends_sql).to eq([user1, user2])
        end
      end

      describe '#non_friends_and_pending' do
        it 'should return users who are not friends or have been sent pending friend requests' do
          Friendship.create!(friend_a: user, friend_b: user1)
          Friendship.create!(friend_a: user2, friend_b: user)
          FriendRequest.create!(recipient: user3, requester: user)
          FriendRequest.create!(recipient: user, requester: user4)
          user5 = FactoryBot.create(:user)
          expect(user.non_friends_and_pending).to eq([user3, user5])
        end
      end

      describe '#no_contacts' do
        it 'should return all users who are not a friend or part of a pending friend request' do
          Friendship.create!(friend_a: user, friend_b: user1)
          Friendship.create!(friend_a: user2, friend_b: user)
          FriendRequest.create!(recipient: user3, requester: user)
          FriendRequest.create!(recipient: user, requester: user4)
          user5 = FactoryBot.create(:user)
          expect(user.no_contacts).to eq([user5])
        end
      end

    end
  end

  describe '#set_avatar!' do
    it 'should set a user\'s avatar' do
      user.save!
      user.set_avatar!
      expect(user.avatar.attached?).to be true
    end
  end
end
