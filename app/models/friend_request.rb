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
  validate :no_self_referential_friendships
  validate :request_in_one_direction_only

  belongs_to :requester, class_name: :User
  belongs_to :recipient, class_name: :User

  private

  def no_self_referential_friendships
    if requester_id == recipient_id
      errors[:recipient_id] << 'No self referential friendships allowed'
    end
  end

  def request_in_one_direction_only
    if FriendRequest.exists?(requester_id: recipient_id, recipient_id: requester_id)
      errors[:recipient_id] << 'There is a pending request from this user'
    end
  end
end
