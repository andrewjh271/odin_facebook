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

  belongs_to :requester, class_name: :User
  belongs_to :recipient, class_name: :User
end
