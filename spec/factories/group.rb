FactoryGirl.define do
  factory :group  do
    name Forgery::Basic.text
    summary Forgery::Basic.text
  end
end
