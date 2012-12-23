FactoryGirl.define do
  factory :post  do
    idx { Forgery::Basic.number }
    subject { Forgery::Basic.text }
    text { Forgery::Basic.text }
  end
end
