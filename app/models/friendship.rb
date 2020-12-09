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
class Friendship < ApplicationRecord
  validates :friend_a_id, uniqueness: { scope: :friend_b_id }

  belongs_to :friend_a, class_name: :User
  belongs_to :friend_b, class_name: :User
end
