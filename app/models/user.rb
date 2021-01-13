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
#  provider               :string
#  uid                    :string
#
require 'open-uri'

class User < ApplicationRecord

  def self.from_omniauth(auth)
    oauth_user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      if auth.info.image
        downloaded_image = URI.open(auth.info.image)
        user.avatar.attach(io: downloaded_image,
                           filename: "image-#{Time.now.strftime("%s%L")}",
                           content_type: downloaded_image.content_type)
      end
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"] ||
         data = session["devise.github_data"] && session["devise.github_data"]["info"]
        user.name = data["name"] if user.name.blank?
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

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
end
