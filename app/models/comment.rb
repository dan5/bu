class Comment < ActiveRecord::Base
  attr_accessible :event_id, :text
  delegate :name, to: :user, prefix: :user

  belongs_to :user
  belongs_to :event
  validates :text, :presence => true,
                   :length => { :maximum => 140 }
end
