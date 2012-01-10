module ApplicationHelper
  def month_day(event)
    t = event.started_at
    "#{t.month}/#{t.day}"
  end
end
