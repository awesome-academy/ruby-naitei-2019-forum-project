User.create!(name: "Example User",
             email: "example@gmail.com",
             password: "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)

9.times do |n|
  name = Faker::Name.name
  email = "example_#{n + 1}@gmail.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.all

users.each do |user|
  10.times do
    name = Faker::Name.name
    description = Faker::Lorem.sentence(5)
    sub_forum = user.sub_forums.create!(name: name, description: description)
    user.join sub_forum, Settings.admin_forum
  end
end

sub_forums = SubForum.all

sub_forums.each do |sub|
  users = User.where.not(id: sub.user_id).order("RANDOM()").first(5)
  users.each { |user| user.join sub, Settings.member_forum }
end
