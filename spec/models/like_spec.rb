# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  post_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Like, type: :model do
  subject(:like) { FactoryBot.build(:like) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:post_id).scoped_to(:user_id) }
  end
end
