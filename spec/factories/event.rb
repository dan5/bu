FactoryGirl.define do
  factory :event  do
    title { Forgery::Basic.text }
    limit { Forgery::Basic.number(at_least: 1, at_most: 100) }
    started_at '2012-01-01 10:00:00'
    ended_at '2012-01-01 10:00:00'
  end
end
