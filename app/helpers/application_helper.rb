# -*- encoding: utf-8 -*-

module ApplicationHelper
  def to_short(str, max, period_size = 3)
    if str.to_s.size > max
      str.to_s.first(max - 1) + '.' * period_size
    else
      str
    end
  end

  def hour_min(time)
    "%02d" % time.hour + ':%02d' % time.min
  end

  def month_day(time)
    "#{time.mon}/#{time.day}"
  end

  def year_month_day(time)
    "#{time.year}/#{time.mon}/#{time.day}"
  end

  def date_time(time)
    time.to_s.sub(/:\d\d \+?\w+/, '').gsub('-', '/')
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
      'atnd'        => '出欠',
      'event'       => '活動',

      'attend'      => '出席する',
      'absent'      => '欠席する',
      'attendance'  => '出席',
      'absence'     => '欠席',
      'maybe'       => '微妙',
      'no answer'   => '無回答',
      'cancel'      => '取り消し',
      'unknown'     => '未入力',

      'my page'     => 'マイページ',
      'new group'   => '新しい部活を作る',
      'events'      => '活動スケジュール',
      'your groups' => '参加している部活',
      'ended'       => '終了しました',

      # users
      'state'       => '状態',
      'mail'        => 'メール',
      'role'        => '役職',
      'set role'    => '役職設定',
      'admin menu'  => '管理メニュー',
      "'s atnds"    => 'の出欠一覧',

      # my
      'update'      => '更新情報',
      'bbs'         => '掲示板',

      # groups
      'groups'      => '部活リスト',
      'users'       => '部員',
      'owner'       => '部長',
      'join this group' => 'この部活に参加する',
      'leave this group' => 'この部活を退部する',
      'new events'  => '新しいスケジュールを追加',
      'new user'    => '新入部員',
      'new posts'   => '掲示板に書き込む',
      'read more'   => 'もっと読む',
      # %w(新人 新入部員 レギュラー 準レギュラー レアキャラ 幽霊部員 休部).sample
      'name'        => '名前',
      'permission'  => '入部制限',
      'summary'     => '概要',
      'description' => '詳しい説明',
      'listing users' => '部員リスト',
      'listing requests' => '参加リクエスト',
      'ask to join this group' => 'この部活への参加リクエストを送る',
      'cancel request to join' => '参加リクエストをキャンセル',

      # posts
      'notification' => 'メンバーへのメール通知',
      "don't notify to members" => 'しない',
      'notify to members' => 'する',
      'subject'     => '件名',
      'post'        => '書きこむ',
      'posts'       => '掲示板',

      # events
      'event owner' => '作成者',
      'date'        => '日時',
      'limit'       => '定員',
      'place'       => '場所',
      'address'     => '住所',
      'public'      => '誰でも参加できる',
      'must be allowed' => '許可が必要',
      'secret'      => '非公開',
      'new event'   => '新しいスケジュール',

      'your state'  => 'あなたの出欠',
      'attendees'   => '参加者',
      'absentees'   => '欠席者',
      'maybees'     => '微妙',
      'waitingattendees' => 'キャンセル待ち',

      'comments and logs' => 'コメントとログ',
    }
  end
end
