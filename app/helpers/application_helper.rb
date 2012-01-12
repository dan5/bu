# -*- encoding: utf-8 -*-

module ApplicationHelper
  def to_short(str, max)
    if str.size > max
      str.first(max) + '...'
    else
      str
    end
  end

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

  # language support --

  def _(str)
    key = str.to_s.downcase
    lang = session[:language] || 'japanese' # default lang is japanese
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
      'unknown'     => '未入力',

      'my page'     => 'マイページ',
      'new group'   => '新しい部活を作る',
      'events'      => '活動スケジュール',
      'your groups' => '参加している部活',
      'ended'       => '終了',

      # groups
      'groups'      => '部活リスト',
      'users'       => '部員',
      'owner'       => '部長',
      'join this group' => 'この部活に参加する',
      'new events'  => '新しいスケジュールを追加',
      'new user'    => '新入部員',
      # %w(新人 新入部員 レギュラー 準レギュラー レアキャラ 幽霊部員 休部).sample
      'name'        => '名前',
      'permission'  => '入部制限',
      'description' => '詳細',

      # events
      'public'      => '誰でも参加できる',
      'must be allowed' => '許可が必要',
      'secret'      => '非公開',
      'new event'   => '新しいスケジュール',

      'your state'  => 'あなたの出欠',
      'attendees'   => '参加者',
      'maybees'     => '微妙な人',
      'absentees'   => '欠席者',
    }
  end
end
