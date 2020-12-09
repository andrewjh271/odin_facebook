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
require 'rails_helper'

RSpec.describe Friendship, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
