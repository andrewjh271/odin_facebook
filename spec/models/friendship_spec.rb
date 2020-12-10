# == Schema Information
#
# Table name: friendships
#
#  id          :bigint           not null, primary key
#  friend_a_id :bigint           not null
#  friend_b_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Friendship, type: :model do
  subject(:friendship) { FactoryBot.build(:friendship) }

  describe 'associations' do
    it { should belong_to(:friend_a) }
    it { should belong_to(:friend_b) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:friend_a_id).scoped_to(:friend_b_id) }

    context 'custom validations' do
      let(:user1) { FactoryBot.create(:user) }
      let(:user2) { FactoryBot.create(:user) }

      describe '#no_self_referential_friendships' do
        it 'should not allow a user to be friends with themselves' do
          invalid_friendship = Friendship.new(friend_a: user1, friend_b: user1)
          expect(invalid_friendship.valid?).to be false
        end
      end

      describe '#no_duplicated_friendships' do
        it 'should not allow a duplicated friendship in the opposite direction' do
          Friendship.create!(friend_a: user1, friend_b: user2)
          invalid_friendship = Friendship.new(friend_a: user2, friend_b: user1)
          expect(invalid_friendship.valid?).to be false
        end
      end
    end
  end
end
