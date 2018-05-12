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

thorin = User.new(email: "thorin@mail.com", password: "qwerasdf", password_confirmation: "qwerasdf", username: "Thorin", name: "Thorin Oakenshield")
thorin.skip_confirmation!
thorin.save!

marty = User.new(email: "marty@mail.com", password: "qwerasdf", password_confirmation: "qwerasdf", username: "Marty", name: "Marty Mcfly")
marty.skip_confirmation!
marty.save!

emmett = User.new(email: "emmett@mail.com", password: "qwerasdf", password_confirmation: "qwerasdf", username: "DocBrown", name: "Emmett Brown")
emmett.skip_confirmation!
emmett.save!

50.times do
  bilbo.pods.create!(content: Faker::Hobbit.quote)
  thorin.pods.create!(content: Faker::Hobbit.quote)
  marty.pods.create!(content: Faker::BackToTheFuture.quote.slice(0..255))
  emmett.pods.create!(content: Faker::BackToTheFuture.quote.slice(0..255))
end

marty.follow(emmett)
marty.follow(thorin)
emmett.follow(thorin)
thorin.follow(emmett)

puts "Seed OK"
