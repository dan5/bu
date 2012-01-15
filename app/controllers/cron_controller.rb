class CronController < ApplicationController
  def update
    events = Event.where("ended_at < ? and ended = ?", Time.now, false)
    events.each do |event|
      event.update_attributes(:ended => true)
      #event.atnds.each do |atnd|
      #  p a
      #end
    end
  end
end
