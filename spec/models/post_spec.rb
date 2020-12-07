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
require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { FactoryBot.build(:post) }

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe 'associations' do
    it { should belong_to(:author) }
  end
end
