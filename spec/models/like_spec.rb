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
require 'rails_helper'

RSpec.describe Like, type: :model do
  subject(:like) { FactoryBot.build(:like) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:likable) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:user_id).scoped_to([:likable_type, :likable_id]) }
  end
end
