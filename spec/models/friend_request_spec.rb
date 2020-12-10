# == Schema Information
#
# Table name: friend_requests
#
#  id           :bigint           not null, primary key
#  requester_id :bigint           not null
#  recipient_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  subject(:friend_request) { FactoryBot.build(:friend_request) }

  describe 'validations' do
    it { should validate_uniqueness_of(:recipient_id).scoped_to(:requester_id) }

    context 'custom validations' do
      let(:user1) { FactoryBot.create(:user) }
      let(:user2) { FactoryBot.create(:user) }

      describe '#no_self_referential_friend_requests' do
        it 'should not allow self referential friend requests' do
          invalid_request = FriendRequest.new(requester: user1, recipient: user1)
          expect(invalid_request.valid?).to be false
        end
      end

      describe '#request_in_one_direction_only' do
        it 'should not allow a duplicate friend request in the other direction' do
          FriendRequest.create(requester: user1, recipient: user2)
          invalid_request = FriendRequest.new(requester: user2, recipient: user1)
          expect(invalid_request.valid?).to be false
        end
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:recipient) }
    it { should belong_to(:requester) }
  end
end