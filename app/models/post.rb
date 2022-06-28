# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  author_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :author,
    class_name: :User

  has_many :likes,
    as: :likable,
    dependent: :destroy

  has_many :comments,
    as: :commentable,
    dependent: :destroy

  has_one_attached :photo

  validate :contains_text_or_photo

  def history
    history = 
      if created_at > 4.days.ago
        time_ago_in_words(created_at) + ' ago'
      else
        created_at.strftime('%b %-d %Y')
      end
    (updated_at - created_at < 1) ? history : (history + '<i> (edited)</i>').html_safe
  end

  def total_comments
    comments.to_a.sum { |comment| 1 + comment.comments.length }
  end

  def get_post_or_photo_id
    # necessary in LikesController#referer_url_with_anchor for when likable is a comment
    id
  end

  private

  def contains_text_or_photo
    unless !body.empty? || photo.attached?
      errors.add(:base, :blank, message: 'Post must contain a text and/or photo.')
    end
  end
end
