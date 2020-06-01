FactoryBot.define do
  factory :request do
    detail { Faker::Quote.famous_last_words }
    user
  end
end
