# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  author_id        :bigint           not null
#  commentable_type :string           not null
#  commentable_id   :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Comment < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :author, class_name: :User
  belongs_to :commentable, polymorphic: true
  has_many :comments,
    as: :commentable,
    dependent: :destroy

  has_many :likes,
    as: :likable,
    dependent: :destroy

  validates :body, presence: true

  def history
    # if (Time.now - created_at) / 60 / 60 / 24 < 200
    #   created_at.strftime("%b %-d")
    # else
    #   created_at.strftime("%b '%y")
    # end
    created_at.strftime("%b %-d '%y")
  end

  def get_post_or_photo_id
    parent = commentable
    parent = parent.commentable while parent.class == Comment
    parent.id
  end
  
  def unnested_commentable_id
    if commentable.class == Comment
      commentable.commentable_id
    else
      commentable_id
    end
  end

  def get_placeholder
    if commentable.class == Comment
      "Reply to #{commentable.author.name}..."
    else
      'Write a comment...'
    end
  end
end
