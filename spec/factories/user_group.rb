FactoryGirl.define do
  factory :user_group  do
    user_id { Forgery::Basic.number }
    group_id { Forgery::Basic.number }
  end
end
