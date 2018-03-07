FactoryBot.define do
  factory :user do |f|

  end

  trait :user_frank do
    name "Frank"
    email "frank@example.com"
    password "fred"
    password_confirmation "fred"
  end

  trait :user_jen do
    name "Jen"
    email "jennylama@me.com"
    password "bernini"
    password_confirmation "bernini"
  end

  trait :user_fred do
    name "Fred"
    email "fred@example.com"
    password "smith"
    password_confirmation "smith"
  end

end