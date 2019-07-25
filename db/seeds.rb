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
               password_confirmation: password)
end

users = User.all

users.each do |user|
  10.times do
    name = Faker::Name.name
    description = Faker::Lorem.sentence(5)
    user.sub_forums.create!(name: name, description: description)
  end
end
