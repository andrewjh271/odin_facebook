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
class FriendRequest < ApplicationRecord
  validates :recipient_id, uniqueness: { scope: :requester_id }
  validate :no_self_referential_friend_requests
  validate :request_in_one_direction_only
  validate :no_requests_to_current_friends, if: -> { requester }

  belongs_to :requester, class_name: :User
  belongs_to :recipient, class_name: :User

  private

  def no_self_referential_friend_requests
    if requester_id == recipient_id
      errors.add(:recipient_id, :blank, message: 'No self referential friend requests allowed.')
    end
  end

  def request_in_one_direction_only
    if FriendRequest.exists?(requester_id: recipient_id, recipient_id: requester_id)
      errors.add(:recipient_id, :blank, message: 'There is a pending request from this user.')
    end
  end

  def no_requests_to_current_friends
    if requester.friends.any? { |friend| friend.id == recipient.id }
      errors.add(:recipient_id, :blank, message: 'User is already friends with this recipient.')
    end
  end
end
