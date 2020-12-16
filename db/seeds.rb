# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def random_likable
  @likables.pop
end

def random_likable_reset!(n)
  @likables = (0...n).to_a.shuffle
end

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

  users = []
  30.times do
    users << User.create!(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: ENV['SEED_USER_PASSWORD']
    )
  end

  sample_user = User.create!(
    name: 'Odin',
    email: 'odin@example.com',
    password: 'password'
  )

  users << sample_user

  posts = []
  110.times do |i|
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
      author: users[rand(users.length)],
      created_at: date,
      updated_at: date
    )
  end

  sample_post = Post.create!(
    body: Faker::GreekPhilosophers.quote,
    author: sample_user
  )

  posts << sample_post

  comments = []
  posts.each do |post|
    rand(5).times do
      user = users[rand(users.length)]
      date = Faker::Date.between(from: post.created_at, to: Date.today)
      body = Faker::Quote.jack_handey
      comments << Comment.create!(commentable: post,
                                  author: user,
                                  body: body,
                                  created_at: date,
                                  updated_at: date)
    end
  end

  nested_comments = []
  comments.each do |comment|
    rand(3).times do
      user = users[rand(users.length)]
      date = Faker::Date.between(from: comment.created_at, to: Date.today)
      body = Faker::Movies::HitchhikersGuideToTheGalaxy.marvin_quote
      nested_comments << Comment.create!(commentable: comment,
                                         author: user,
                                         body: body,
                                         created_at: date,
                                         updated_at: date)
    end
  end

  users.length.times do |i|
    random_likable_reset!(posts.length)
    rand(posts.length / 2).times { Like.create!(likable: posts[random_likable], user: users[i]) }

    random_likable_reset!(comments.length)
    rand(comments.length / 2).times { Like.create!(likable: comments[random_likable], user: users[i]) }

    random_likable_reset!(nested_comments.length)
    rand(nested_comments.length / 2).times { Like.create!(likable: nested_comments[random_likable], user: users[i]) }
  end
end