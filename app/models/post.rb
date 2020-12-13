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
    dependent: :destroy

  has_many :comments,
    as: :commentable,
    dependent: :destroy

  validates :body, presence: true

  def history
    history = 
      if created_at > 4.days.ago
        time_ago_in_words(created_at) + ' ago'
      else
        created_at.strftime('%b %-d %Y')
      end
    created_at == updated_at ? history : (history + '<i> (edited)</i>').html_safe
  end
end
