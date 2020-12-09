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
FactoryBot.define do
  factory :friendship do
    friend_a { nil }
    friend_b { nil }
  end
end
