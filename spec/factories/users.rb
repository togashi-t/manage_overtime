FactoryBot.define do
  factory :user do
    name { Gimei.unique.name.kanji }
    group { ("A".."Z").to_a.sample }
    sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
    password { Faker::Internet.password }
  end
end
