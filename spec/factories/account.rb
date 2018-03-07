FactoryBot.define do
  factory :account do |f|

  end

  trait :account_master do
    name "AccountMaster"
  end

  trait :account_detail do
    name "AccountDetail"
  end
end