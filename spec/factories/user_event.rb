FactoryGirl.define do
  factory :user_event  do
    user_id { Forgery::Basic.number }
    event_id { Forgery::Basic.number }
    state { Forgery::Basic.text }
  end
end
