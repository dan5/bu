# -*- encoding: utf-8 -*-

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

  def _(str)
    key = str.to_s.downcase
    lang = session[:language] || 'japanese'
    %w(english japanese).include?(lang) or raise
    return str if lang == 'english'
    begin
      send("_#{lang}_#{controller_name}")[key] or send("_#{lang}_default")[key] or str
    rescue NoMethodError
      send("_#{lang}_default")[key] or str
    end
  end

  def _japanese_default
    {
      'attend'      => '出席する',
      'absent'      => '欠席する',
      'attendance'  => '出席',
      'absence'     => '欠席',
      'maybe'       => '微妙',
      'cancel'      => '取り消し',

      'my page'     => 'マイページ',
      'new group'   => '新しい部活を作る',
      'events'      => '活動スケジュール',
      'your groups' => '参加している部活',
      'hello'       => 'こんにちは',
    }
  end
end
