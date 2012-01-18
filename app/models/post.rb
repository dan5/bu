class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  validates_uniqueness_of :idx, :scope => [:group_id]
  validates :subject, :length => { :maximum => 40 }
  validates :text, :length => { :minimum => 1, :maximum => 1000 }
end
