class Comment < ActiveRecord::Base
  attr_accessible :event_id, :text

  belongs_to :user
  belongs_to :event
  validates :text, :presence => true,
                   :length => { :maximum => 140 }
end
