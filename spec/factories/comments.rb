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
FactoryBot.define do
  factory :comment do
    body { "MyText" }
    author { create(:user) }
    commentable { create(:post) }
  end
end
