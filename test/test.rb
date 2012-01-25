# -*- encoding: utf-8 -*-
require './lib/mytest'

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

  @group_name = "TAKO-#{uniq_string(8)}"
  @event_name = "YAKI-#{uniq_string(8)}"
end

# new group
context 'group:create' do 
  context "Name can't be blank" do
    get '/' 
    click :text => 'new group'
    page_form_with(:new_group, :group, :summary => 'summary').click_button
    assert page.uri.path == '/groups'
    shuld_have_content "Name can't be blank"
  end

  context "Summary can't be blank => success" do
    get '/' 
    click :text => 'new group'
    # failure
    page_form_with(:new_group, :group, :name => @group_name).click_button
    assert page.uri.path == '/groups'
    shuld_have_content "Summary can't be blank"
    # success
    page_form_with(:new_group, :group, :name => @group_name, :summary => 'hello').click_button
    @group_id = page.uri.path.match(%r!^/groups/(\d+)!)[1]
    assert "/groups/#{@group_id}" == page.uri.path
    shuld_have_content @group_name
    shuld_have_content 'Group was successfully created.'
  end
end

context 'group:edit' do 
  get '/my'
  click :text => @group_name
  click :text => 'Edit'
  shuld_have_content 'Editing group'
  page_form_with("edit_group_#{@group_id}", :group, :description => 'hello world!!').click_button
  assert "/groups/#{@group_id}" == page.uri.path
end

context 'event' do 
  context 'create' do 
    get '/my'
    click :text => @group_name
    click :text => 'new event'
    page_form_with(:new_event, :event, :title => @event_name).click_button
    assert %r(/events/\d+) === page.uri.path
    shuld_have_content 'Event was successfully created.'
    shuld_have_content @event_name
    get '/my'
    shuld_have_content @event_name
  end
end

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

context 'posts:create' do
  get '/my'
  click :text => @group_name
  click :text => 'new post'
  # post
  page_form_with(:new_post, :post, :text => 'first post').click_button
  shuld_have_content 'first post', 'div.body'
  # post again
  page_form_with(:new_post, :post, :text => 'second post').click_button
  shuld_have_content 'second post', 'div.body'
end
