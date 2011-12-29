class Group < ActiveRecord::Base
  has_many :events

  def owner
    User.find_by_id(owner_user_id) # trap: 例外を発生させない
  end
end
