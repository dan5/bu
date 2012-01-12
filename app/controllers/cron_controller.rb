class CronController < ApplicationController
  def update
    events = Event.find(:all, :conditions => ["ended_at < ? and ended = ?", Time.now, false])
    events.each do |event|
      event.update_attributes(:ended => true)
      #event.atnds.each do |atnd|
      #  p a
      #end
    end
  end
end
