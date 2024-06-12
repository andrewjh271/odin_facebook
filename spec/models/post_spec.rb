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
  

  describe 'validations' do
    it 'should contain a body and/or photo' do
      post = FactoryBot.build(:post, body: '')
      expect(post.valid?).to be false
    end

    it 'should be valid with body and no photo' do
      post = FactoryBot.build(:post)
      expect(post.valid?).to be true
    end

    it 'should be valid if a photo is attached with no body' do
      post = FactoryBot.build(:post, body: '')
      filename = '1.png'
      path = Rails.root.join('app/assets/images/Default Avatars', filename)
      File.open(path) do |io|
        post.photo.attach(io: io, filename: filename)
        post.save!
      end
      expect(post.valid?).to be true
    end
  end

  describe 'associations' do
    subject(:post) { FactoryBot.build(:post) }

    it { should belong_to(:author) }
    it { should have_many(:likes) }
    it { should have_many(:comments) }
    it { should have_one_attached(:photo) }
  end
end
