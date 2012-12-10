FactoryGirl.define do
  factory :user  do
    uid Forgery::Basic.text
    provider 'twitter'
    name Forgery::Basic.text
    mail Forgery::Email.address
    image 'https://si0.twimg.com/profile_images/2268491806/anq8ftu9ceoxzik2h2wj.png'
  end
end
