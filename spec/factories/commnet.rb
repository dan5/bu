FactoryGirl.define do
  factory :comment  do
    text { Forgery::Basic.text }
  end
end
