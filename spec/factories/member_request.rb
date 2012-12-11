FactoryGirl.define do
  factory :member_request  do
    user_id { Forgery::Basic.number }
    group_id { Forgery::Basic.number }
  end
end
