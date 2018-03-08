FactoryBot.define do
  factory :content do |f|

  end

  trait :private_for_edit do
    private true
    content_text 'private content'
  end

  trait :public_for_edit do
    private false
    content_text 'private content'
  end

end