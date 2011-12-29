class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, :through => :user_groups
end
