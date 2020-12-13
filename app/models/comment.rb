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
  belongs_to :author, class_name: :User
  belongs_to :commentable, polymorphic: true
  has_many :comments,
    as: :commentable,
    dependent: :destroy

  validates :body, presence: true
end
