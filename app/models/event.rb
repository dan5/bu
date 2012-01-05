class Event < ActiveRecord::Base
  belongs_to :group
  has_many :user_events
  has_many :users, :through => :user_events
  def atnds(*args) user_events(*args) end
end
