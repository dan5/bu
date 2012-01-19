class CronController < ApplicationController

  private

  def update
    update_events
  end

  def update_events
    Event.transaction do
      events = Event.where("ended_at < ? and ended = ?", Time.now, false)
      events.each do |event|
        event.update_attributes(:ended => true)
        event.waitings.each do |user_event|
          user_event.state = 'absence'
          user_event.save
        end
      end
    end
  end
end
