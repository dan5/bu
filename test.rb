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
  click :text => 'English'
  shuld_have_content 'Japanese'
  @group_name = "TAKO-#{Time.now.to_i.to_s(36)}"
  @event_name = "YAKI-#{Time.now.to_i.to_s(36)}"
end

# new group
context 'group:create' do 
  get '/' 
  click :text => 'new group'
  page.form_with(:id => 'new_group') {|form|
    form.field_with(:name => 'group[name]').value = @group_name
    # todo: empty
    form.field_with(:name => 'group[summary]').value = 'summary'
    form.click_button
  }
  assert page.uri.path[%r(/groups/\d+)]
  shuld_have_content @group_name
  shuld_have_content 'Group was successfully created.'
  click :text => 'Edit'
  get '/my'
  shuld_have_content @group_name
end

context 'event' do 
  context 'create' do 
    get '/my'
    click :text => @group_name
    click :text => 'new event'
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
  click :text => @event_name
  [
    %w(attend Attendance div.attendees),
    %w(absent Absence div.absentees),
    %w(maybe Maybe div.absentees), # trap: div.absentees
  ].each do |action, state, state_class|
    # action
    puts action
    click :text => action
    shuld_have_content state, 'div.state'
    shuld_have_content 'testman', state_class
    # cansel
    click :text => 'cancel'
    shuld_not_have_content 'testman', state_class
  end
  
  # attend from group#show
  get '/my'
  click :text => @group_name
  %w(attend absent maybe).each do |action|
    puts action
    click :text => action
    click :text => 'cancel'
    shuld_not_have_content 'cancel'
  end
  
  # attend from my
  get '/my'
  %w(attend absent maybe).each do |action|
    puts action
    click :text => action
    click :text => 'cancel'
    #shuld_not_have_content 'cancel'
  end
end

context 'post' do
    get '/my'
    click :text => @group_name
    click :text => 'new post'
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

# todo:  click:text => 'Destroy'




__END__
#agent. click:text => "English"

5.times {
  agent. click:text => "新しい部活を作る"
  puts agent.page.uri
  agent. click:text => "home"
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

