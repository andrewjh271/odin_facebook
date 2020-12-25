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
  validate :no_self_referential_friendships
  validate :no_duplicated_friendships

  belongs_to :friend_a, class_name: :User
  belongs_to :friend_b, class_name: :User

  def self.search(friend_a_id, friend_b_id)
    Friendship
      .where('friend_a_id = ? AND friend_b_id = ?', friend_a_id, friend_b_id)
      .or(
    Friendship
      .where('friend_b_id = ? AND friend_a_id = ?', friend_a_id, friend_b_id)
      ).first
  end

  private
  
  def no_self_referential_friendships
    if friend_a_id == friend_b_id
      errors[:base] << 'No self referential friendships allowed'
    end
  end

  def no_duplicated_friendships
    if Friendship.exists?(friend_a_id: friend_b_id, friend_b_id: friend_a_id)
      errors[:base] << 'This friendship already exists with the opposite references'
    end
  end
end
