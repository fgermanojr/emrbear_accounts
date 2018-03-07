FactoryBot.define do
  factory :relationship do |f|

  end
  # note. i am not reusing accounts or users below; this is why it works; otherwise aleady exist errors
  # TBD how to specify specific user via trait on association below, although this works
  trait :account_master_user_frank_owner do
    association :user, {name: 'frank', email: 'frank@germano.org', password:'a', password_confirmation:'a'}
    association :account, {name: 'AccountMaster'}
    relationship_type 'owner'
  end

  trait :account_detail_user_jen_owner do
    association :user, {name: 'jen', email: 'jennylama@me.com', password:'a', password_confirmation:'a'}
    association :account, {name: 'AccountDetail'}
    relationship_type 'owner'
  end

  trait :account_favorite_user_tess_member do
    association :user, {name: 'tess', email: 'tess@germano.org', password:'a', password_confirmation:'a'}
    association :account, {name: 'AccountFavorite'}
    relationship_type 'member'
  end
end