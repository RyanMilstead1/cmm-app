FactoryBot.define do
  pw = Faker::Internet.password
  un = Faker::GameOfThrones.character.gsub(/\W/, "")

  factory :user do
    sequence(:username){|n| "#{un}#{n}"}
    sequence(:email){|n| "user#{n}@blocipedia.io"}
    password pw
    password_confirmation pw
  end
end
