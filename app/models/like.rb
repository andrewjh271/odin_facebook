# == Schema Information
#
# Table name: likes
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  likable_type :string           not null
#  likable_id   :bigint           not null
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likable, polymorphic: true

  validates :user_id, uniqueness: { scope: [:likable_type, :likable_id] }

  def get_post_or_photo_id
    parent = likable
    parent = parent.likable while parent.class == Comment
    parent.id
  end
end
