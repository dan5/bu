class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  validates_uniqueness_of :idx, :scope => [:group_id]
  validates :text, :length => { :minimum => 1, :maximum => 1000 }
end
