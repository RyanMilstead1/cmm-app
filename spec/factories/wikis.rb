FactoryBot.define do
  factory :wiki do
    title Faker::Hacker.say_something_smart
    body Faker::Hipster.paragraph
    private false
    user
  end
end
