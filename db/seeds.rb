5.times do
  pw = Faker::Internet.password
  un = Faker::GameOfThrones.character.gsub(/\W/, "")
  User.create!(
    username: un,
    email: "#{un}@blocipedia.com",
    password: pw,
    password_confirmation: pw
  )
end

users = User.all

10.times do
  Wiki.create!(
  title: Faker::Hacker.say_something_smart,
  body: "### Section 1\n#{Faker::Hipster.paragraph}\n#### Sub A\n#{Faker::Hipster.paragraph}\n> #{Faker::StarWars.quote}\n- #{Faker::StarWars.character}\n\n### Section 2\n#{Faker::Hipster.paragraph}",
  private: true,
  user: users.sample
  )
end

private_wikis = Wiki.all

20.times do
  Wiki.create!(
    title: Faker::Hacker.say_something_smart,
    body: "### Section 1\n#{Faker::Hipster.paragraph}\n#### Sub A\n#{Faker::Hipster.paragraph}\n> #{Faker::StarWars.quote}\n- #{Faker::StarWars.character}\n\n### Section 2\n#{Faker::Hipster.paragraph}",
    private: false,
    user: users.sample
  )
end

30.times do
  Collaborator.create!(
    user: users.sample,
    wiki: private_wikis.sample
  )
end

User.create!(
  email: "admin@test.com",
  username: "admin",
  password: "password",
  password_confirmation: "password",
  role: :admin
)

User.create!(
  email: "standard@test.com",
  username: "standard",
  password: "password",
  password_confirmation: "password"
)

Collaborator.create!(
  user: User.last,
  wiki: private_wikis.sample
)

User.create!(
  email: "premium@test.com",
  username: "premium",
  password: "password",
  password_confirmation: "password",
  role: :premium
)

Wiki.create!(
  title: Faker::Hacker.say_something_smart,
  body: "### Section 1\n#{Faker::Hipster.paragraph}\n#### Sub A\n#{Faker::Hipster.paragraph}\n> #{Faker::StarWars.quote}\n- #{Faker::StarWars.character}\n\n### Section 2\n#{Faker::Hipster.paragraph}",
  private: true,
  user: User.last
)

puts "Seed complete"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
puts "#{Collaborator.count} collaborators created"
