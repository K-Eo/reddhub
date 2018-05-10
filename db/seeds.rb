# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

bilbo = User.new(email: "bilbo@mail.com", password: "qwerasdf", password_confirmation: "qwerasdf", username: "Bilbo", name: "Bilbo Baggins")
bilbo.skip_confirmation!
bilbo.save!

50.times do
  bilbo.pods.create!(content: Faker::Hobbit.quote)
end

thorin = User.new(email: "thorin@mail.com", password: "qwerasdf", password_confirmation: "qwerasdf", username: "Thorin", name: "Thorin Oakenshield")
thorin.skip_confirmation!
thorin.save!

50.times do
  thorin.pods.create!(content: Faker::Hobbit.quote)
end

puts "Seed OK"
