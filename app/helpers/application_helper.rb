module ApplicationHelper
  def month_day(event)
    t = event.started_at
    "#{t.month}/#{t.day}"
  end

  def date_time(time)
    time.to_s.sub(/:\d\d \w+/, '')
  end

  def simple_html_compiler(str)
    h(str).gsub("\n", '<br />')
  end
end
