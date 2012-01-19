class CronController < ApplicationController
  def update
    Event.be_ended_all
  end
end
