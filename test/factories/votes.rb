FactoryGirl.define do
  factory :vote do
    association :votable, factory: :post
    value 1
    user
  end
end
