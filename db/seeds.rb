# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def random_likable
  @likable_indices.pop
end

def random_likable_reset!(n)
  @likable_indices = (0...n).to_a.shuffle
end

def assign_avatar!(user, name)
  filename = "#{name}.jpg"
  path = Rails.root.join("app/assets/images/Seed Avatars", filename)
  File.open(path) do |io|
    user.avatar.attach(io: io, filename: filename)
  end
end

def user_params(name)
  random = rand
  education1 = Faker::University.name if random > 0.2
  education2 = Faker::University.name if random > 0.5
  education3 = Faker::University.name if random > 0.8
  occupation = Faker::Job.title if rand < 0.8
  {
    name: name,
    email: Faker::Internet.email,
    password: ENV['SEED_USER_PASSWORD'],
    education1: education1,
    education2: education2,
    education3: education3,
    location: Faker::Address.city,
    occupation: occupation,
    birthday: Faker::Date.birthday(min_age: 18, max_age: 65)
  }
end

@users = []

ActiveRecord::Base.transaction do
  Friendship.destroy_all
  FriendRequest.destroy_all
  Like.destroy_all
  Comment.destroy_all
  Post.destroy_all
  User.destroy_all

  ActiveRecord::Base.connection.reset_pk_sequence!('likes')
  ActiveRecord::Base.connection.reset_pk_sequence!('posts')
  ActiveRecord::Base.connection.reset_pk_sequence!('users')
  ActiveRecord::Base.connection.reset_pk_sequence!('friendships')
  ActiveRecord::Base.connection.reset_pk_sequence!('friend_requests')
  ActiveRecord::Base.connection.reset_pk_sequence!('comments')

  50.times do |i|
    first_name = i <= 27 ? Faker::Name.female_first_name : Faker::Name.male_first_name
    name = "#{first_name} #{Faker::Name.last_name}"
    @users << User.create!(user_params(name))
  end

  sample_user = User.create!(
    name: 'Odin',
    email: 'odin@example.com',
    password: 'password',
    education1: 'Mead of Poetry',
    location: 'Iceland',
    occupation: 'God of Knowledge',
    website: 'www.theodinproject.com',
    birthday: '1/12/0040'
  )
  @users << sample_user

  # create posts
  posts = []
  200.times do |i|
    date = Faker::Date.between(from: 2.years.ago, to: Date.today)
    body = case i
           when 0..30 then Faker::GreekPhilosophers.quote
           when 31..50 then Faker::Quotes::Shakespeare.hamlet_quote
           when 51..70 then Faker::Quotes::Shakespeare.as_you_like_it_quote
           when 71..90 then Faker::Quotes::Shakespeare.king_richard_iii_quote
           else Faker::Quotes::Shakespeare.romeo_and_juliet_quote
           end

    posts << Post.create!(
      body: body,
      author: @users[rand(@users.length)],
      created_at: date,
      updated_at: date
    )
  end

  sample_post = Post.create!(
    body: Faker::GreekPhilosophers.quote,
    author: sample_user
  )

  posts << sample_post

  # create comments
  comments = []
  posts.each do |post|
    rand(5).times do
      user = @users[rand(@users.length)]
      date = Faker::Date.between(from: post.created_at, to: Date.today)
      body = Faker::Quote.jack_handey
      comments << Comment.create!(commentable: post,
                                  author: user,
                                  body: body,
                                  created_at: date,
                                  updated_at: date)
    end
  end

  # create nested comments
  nested_comments = []
  comments.each do |comment|
    rand(3).times do
      user = @users[rand(@users.length)]
      date = Faker::Date.between(from: comment.created_at, to: Date.today)
      body = Faker::Movies::HitchhikersGuideToTheGalaxy.marvin_quote
      nested_comments << Comment.create!(commentable: comment,
                                         author: user,
                                         body: body,
                                         created_at: date,
                                         updated_at: date)
    end
  end

  # create likes
  @users.length.times do |i|
    random_likable_reset!(posts.length)
    rand(posts.length / 2).times { Like.create!(likable: posts[random_likable], user: @users[i]) }

    random_likable_reset!(comments.length)
    rand(comments.length / 3).times { Like.create!(likable: comments[random_likable], user: @users[i]) }

    random_likable_reset!(nested_comments.length)
    rand(nested_comments.length / 3).times { Like.create!(likable: nested_comments[random_likable], user: @users[i]) }
  end

  # create friendships
  @users.length.times do |i|
    user_indices = ((i + 1)...@users.length).to_a.shuffle
    (user_indices.length / 2).times do
      Friendship.create!(friend_a: @users[i], friend_b: @users[(user_indices.pop)])
    end
  end

  # create friend requests for Odin
  sample_user.no_contacts.take(15).each_with_index do |user, i|
    if i < 10
      FriendRequest.create!(requester: user, recipient: sample_user)
    else
      FriendRequest.create!(requester: sample_user, recipient: user)
    end
  end
end

# set seed avatars
@users.each_with_index do |user, index|
  assign_avatar!(user, index)
end