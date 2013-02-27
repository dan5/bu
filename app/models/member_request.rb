class MemberRequest < ActiveRecord::Base
  attr_accessible :group_id

  belongs_to :user
  belongs_to :group
  validates_uniqueness_of :user_id, :scope => [:group_id]
end
