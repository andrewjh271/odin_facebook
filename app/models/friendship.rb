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
  validate :no_duplicated_friendships

  belongs_to :friend_a, class_name: :User
  belongs_to :friend_b, class_name: :User

  private
  
  def no_duplicated_friendships
    if Friendship.exists?(friend_a_id: friend_b_id, friend_b_id: friend_a_id)
      errors[:base] << 'This friendship already exists with the opposite references'
    end
  end
end
