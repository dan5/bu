FactoryGirl.define do
  factory :user_group  do
    user_id { Forgery::Basic.number }
    group_id { Forgery::Basic.number }
    state { Forgery::Basic.text }
    role { Forgery::Basic.text }
  end
end
