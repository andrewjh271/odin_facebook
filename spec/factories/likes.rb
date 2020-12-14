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
FactoryBot.define do
  factory :like do
    user { create(:user) }
    likable { create(:post) }
  end
end
