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
require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject(:comment) { FactoryBot.build(:comment) }

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe 'associations' do
    it { should belong_to(:author) }
    it { should have_many(:likes) }
  end
end
