# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  name                   :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :email, presence: true

  has_many :posts,
    foreign_key: :author_id,
    dependent: :destroy
  
  has_many :likes,
    dependent: :destroy

  has_many :friend_requests,
    foreign_key: :requester,
    dependent: :destroy

  has_many :requested_friends,
    through: :friend_requests,
    source: :recipient

  has_many :friend_invitations,
    foreign_key: :recipient,
    class_name: :FriendRequest,
    dependent: :destroy

  has_many :requesting_friends,
    through: :friend_invitations,
    source: :requester

  has_many :friendships,
    ->(user) { unscope(:where).where('friend_a_id = ? OR friend_b_id = ?', user.id, user.id) }

  def friends
    # active_record_union gem makes #union possibile
    join_statement1 = <<-SQL
      INNER JOIN friendships
        ON friendships.friend_a_id = users.id
        AND (friendships.friend_a_id = #{id} OR friendships.friend_b_id = #{id})
    SQL
    join_statement2 = <<-SQL
      INNER JOIN friendships
        ON friendships.friend_b_id = users.id
        AND (friendships.friend_a_id = #{id} OR friendships.friend_b_id = #{id})
    SQL

    User.joins(join_statement1)
        .union(User.joins(join_statement2))
        .where.not(id: id)
  end

  def friends_sql
    # SQL implentation, but returns array instead of ActiveRecord Relation
    User.find_by_sql(<<-SQL)
      SELECT users.*
      FROM users
      INNER JOIN friendships
        ON friendships.friend_a_id = users.id
        AND (friendships.friend_a_id = #{id} OR friendships.friend_b_id = #{id})
      WHERE users.id <> #{id}
      UNION
      SELECT users.*
      FROM users
      INNER JOIN friendships
        ON friendships.friend_b_id = users.id
        AND (friendships.friend_a_id = #{id} OR friendships.friend_b_id = #{id})
      WHERE users.id <> #{id};
    SQL
  end
end
