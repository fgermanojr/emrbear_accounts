FactoryBot.define do
  factory :user do |f|
    f.name "Frank"
    f.email "frank@example.com"
    f.password "fred"
    f.password_confirmation "fred"
  end
end