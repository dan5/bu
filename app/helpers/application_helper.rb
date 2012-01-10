module ApplicationHelper
  def month_day(event)
    t = event.started_at
    "#{t.month}/#{t.day}"
  end

  def simple_html_compiler(str)
    h(str).gsub("\n", '<br />')
  end
end
