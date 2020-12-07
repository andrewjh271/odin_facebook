# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def random_post
  @posts.pop
end

def random_post_reset!(n = 30)
  @posts = (0..n).to_a.shuffle
end

ActiveRecord::Base.transaction do
  # Like.destroy_all
  Post.destroy_all
  User.destroy_all

  users = []
  15.times do
    users << User.create(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: 'mandolin'
    )
  end

  posts = []
  30.times do
    date = Faker::Date.between(from: 2.years.ago, to: Date.today)
    posts << Post.create(
      body: Faker::GreekPhilosophers.quote,
      author: users[rand(users.length)],
      created_at: date,
      updated_at: date
    )
  end

  sample_user = User.create(
    name: 'Odin',
    email: 'odin@example.com',
    password: 'password'
  )

  sample_post = Post.create(
    body: Faker::GreekPhilosophers.quote,
    author: sample_user
  )

  # 15.times do |i|
  #   Like.create(post: sample_post, user: users[i])
  #   random_post_reset!
  #   rand(30).times do
  #     Like.create(post: posts[sample_post], user: users[i])
  #   end
  # end
end