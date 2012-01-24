# -*- encoding: utf-8 -*-
require './mytest'

setup('http://localhost:3000') do
  # login
  get '/'
  shuld_have_content 'Sign in'
  get '/users/test_login'
  shuld_have_content 'ok'

  get '/' 
  shuld_have_content 'Bu'
  shuld_have_content 'Sign out(testman)'

  # set English
  shuld_have_content 'English'
  page.link_with(:text => 'English').click
  shuld_have_content 'Japanese'
  @group_name = "TAKO-#{Time.now.to_i.to_s(36)}"
  @event_name = "YAKI-#{Time.now.to_i.to_s(36)}"
end

# new group
context 'group' do 
  get '/' 
  page.link_with(:text => 'new group').click
  page.form_with(:id => 'new_group') {|form|
    form.field_with(:name => 'group[name]').value = @group_name
    # todo: empty
    form.field_with(:name => 'group[summary]').value = 'summary'
    form.click_button
  }
  assert page.uri.path[%r(/groups/\d+)]
  shuld_have_content @group_name
  shuld_have_content 'Group was successfully created.'
  get '/my'
  shuld_have_content @group_name
end

context 'event' do 
  context 'create' do 
    get '/my'
    page.link_with(:text => @group_name).click
    page.link_with(:text => 'new event').click
    page.form_with(:id => 'new_event') {|form|
      form.field_with(:name => 'event[title]').value = @event_name
      form.click_button
    }
    assert page.uri.path[%r(/events/\d+)]
    shuld_have_content 'Event was successfully created.'
    shuld_have_content @event_name
    get '/my'
    shuld_have_content @event_name
  end
end

#__END__
  
context 'attend' do 
  get '/my'
  page.link_with(:text => @event_name).click
  [
    %w(attend Attendance div.attendees),
    %w(absent Absence div.absentees),
    %w(maybe Maybe div.absentees), # trap: div.absentees
  ].each do |action, state, state_class|
    # action
    puts action
    page.link_with(:text => action).click
    shuld_have_content state, 'div.state'
    shuld_have_content 'testman', state_class
    # cansel
    page.link_with(:text => 'cancel').click
    shuld_not_have_content 'testman', state_class
  end
  
  # attend from group#show
  get '/my'
  page.link_with(:text => @group_name).click
  %w(attend absent maybe).each do |action|
    puts action
    page.link_with(:text => action).click
    page.link_with(:text => 'cancel').click
    shuld_not_have_content 'cancel'
  end
  
  # attend from my
  get '/my'
  %w(attend absent maybe).each do |action|
    puts action
    page.link_with(:text => action).click
    page.link_with(:text => 'cancel').click
    #shuld_not_have_content 'cancel'
  end
end

context 'post' do
    get '/my'
    page.link_with(:text => @group_name).click
    page.link_with(:text => 'new post').click
    page.form_with(:id => 'new_post') {|form|
      form.field_with(:name => 'post[text]').value = 'first post'
      form.click_button
    }
    shuld_have_content 'first post', 'div.body'

    page.form_with(:id => 'new_post') {|form|
      form.field_with(:name => 'post[text]').value = 'second post'
      form.click_button
    }
    shuld_have_content 'second post', 'div.body'
end

# new event

# todo: page.link_with(:text => 'Destroy').click




__END__
#agent.page.link_with(:text => "English").click

5.times {
  agent.page.link_with(:text => "新しい部活を作る").click
  puts agent.page.uri
  agent.page.link_with(:text => "home").click
  puts agent.page.uri
}

__END__
agent.page.form_with(:name => 'f') {|form|
  form.field_with(:name => 'q').value = 'Ruby'
  form.click_button
}

agent.page.link_with(:text => "オブジェクト指向スクリプト言語 Ruby".toutf8).click
puts agent.page.uri
puts agent.page.at('div#logo/img')['alt']
puts agent.page.at('div#logo/img')['width']

