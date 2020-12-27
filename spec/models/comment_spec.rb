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
    it { should belong_to(:commentable) }
    it { should have_many(:likes) }
    it { should have_many(:comments) }
  end

  describe '#history' do
    it 'should give elapsed time in minutes if less than an hour' do
      comment = FactoryBot.build(:comment, created_at: 59.minutes.ago)
      expect(comment.history).to eq('59m')
    end

    it 'should give elapsed time in hours if less than a day' do
      comment = FactoryBot.build(:comment, created_at: 23.hours.ago)
      expect(comment.history).to eq('23h')
    end

    it 'should give elapsed time in weeks if less than a year' do
      comment = FactoryBot.build(:comment, created_at: 364.days.ago)
      expect(comment.history).to eq('52w')
    end

    it 'should otherwise give elapsed time in years' do
      comment = FactoryBot.build(:comment, created_at: 59.weeks.ago)
      expect(comment.history).to eq('1y')
    end
  end
end
