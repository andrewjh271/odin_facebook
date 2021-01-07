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
#  location               :string
#  education1             :string
#  education2             :string
#  education3             :string
#  occupation             :string
#  website                :string
#  birthday               :date
#
require 'open-uri'

class User < ApplicationRecord

  def self.from_omniauth(auth)
    downloaded_image = URI.open(auth.info.image) if auth.info.image
    oauth_user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      if downloaded_image
        user.avatar.attach(io: downloaded_image,
                           filename: "image-#{Time.now.strftime("%s%L")}",
                           content_type: downloaded_image.content_type)
      end
    end
    downloaded_image.close if downloaded_image
    oauth_user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # after_commit :ensure_avatar, unless: :seed_user?
  # after_create :create_friend_invitations, unless: :seed_user?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook github]

  validates :name, :email, presence: true

  has_many :posts,
    foreign_key: :author_id,
    dependent: :destroy
  
  has_many :likes,
    dependent: :destroy

  has_many :comments,
    foreign_key: :author_id,
    dependent: :destroy

  has_many :friend_requests,
    foreign_key: :requester_id,
    dependent: :destroy

  has_many :requested_friends,
    through: :friend_requests,
    source: :recipient

  has_many :friend_invitations,
    foreign_key: :recipient_id,
    class_name: :FriendRequest,
    dependent: :destroy

  has_many :requesting_friends,
    through: :friend_invitations,
    source: :requester

  has_many :friendships,
    ->(user) { unscope(:where).where('friend_a_id = ? OR friend_b_id = ?', user.id, user.id) },
    dependent: :destroy

  has_one_attached :avatar

  def friends
    join_statement = <<-SQL
      INNER JOIN friendships
        ON (friendships.friend_a_id = users.id OR friendships.friend_b_id = users.id)
        AND (friendships.friend_a_id = #{id} OR friendships.friend_b_id = #{id})
    SQL
    User.joins(join_statement)
        .where.not(id: id)
  end

  def friends_sql
    # SQL implentation, but returns array instead of ActiveRecord Relation
    User.find_by_sql(<<~SQL)
      SELECT users.*
      FROM users
      INNER JOIN friendships
        ON (friendships.friend_a_id = users.id OR friendships.friend_b_id = users.id)
        AND (friendships.friend_a_id = #{id} OR friendships.friend_b_id = #{id})
      WHERE users.id <> #{id};
    SQL
  end

  def non_friends_and_pending
    join_statement = <<-SQL
      LEFT OUTER JOIN friendships
        ON (friendships.friend_a_id = users.id OR friendships.friend_b_id = users.id)
        AND (friendships.friend_a_id = #{id} OR friendships.friend_b_id = #{id})
      LEFT OUTER JOIN friend_requests
        ON friend_requests.requester_id = users.id
        AND friend_requests.recipient_id = #{id}
      SQL
    
    User.joins(join_statement)
        .where( friendships: { id: nil }, friend_requests: { id: nil} )
        .where.not(id: id)
  end

  def no_contacts
    join_statement = <<-SQL
      LEFT OUTER JOIN friendships
        ON (friendships.friend_a_id = users.id OR friendships.friend_b_id = users.id)
        AND (friendships.friend_a_id = #{id} OR friendships.friend_b_id = #{id})
      LEFT OUTER JOIN friend_requests
        ON (friend_requests.requester_id = users.id OR friend_requests.recipient_id = users.id)
        AND (friend_requests.requester_id = #{id} OR friend_requests.recipient_id = #{id})
      SQL
    
    User.joins(join_statement)
        .where( friendships: { id: nil }, friend_requests: { id: nil} )
        .where.not(id: id)
  end

  def set_avatar!
    filename = "#{rand(15)}.png"
    path = Rails.root.join("app/assets/images/Default Avatars", filename)
    File.open(path) do |io|
      avatar.attach(io: io, filename: filename)
    end
  end

  def formatted_birthday
    birthday.strftime('%B %-d')
  end

  private

  REQUESTING_FRIENDS_IDS = [1, 5, 8, 24, 25, 26, 31, 39, 48, 50]

  def ensure_avatar
    set_avatar! unless avatar.attached?
  end

  def create_friend_invitations
    REQUESTING_FRIENDS_IDS.each do |requester_id|
      friend_request = friend_invitations.build(requester_id: requester_id)
      friend_request.save
    end
  end

  def seed_user?
    id <= 51
  end
end
