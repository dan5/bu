# -*- encoding: utf-8 -*-
require './lib/mytest'

setup('http://localhost:3000') do
  get '/'

  get '/my' 
  shuld_be_path '/users/new'

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

context 'users setting' do
  context 'input mail' do
    get '/my' 
    click :text => 'Please input your mail address'
    @user_id = page.body.match(/edit_user_(\d+)/)[1]
    page_form_with("edit_user_#{@user_id}", :user, :mail => 'testman@example.com').click_button
    shuld_not_have_content 'Please input your mail address'
  end
end

context 'group:destroy all of mine' do 
  get '/my' 
  group_names = page.search('table.groups a').map(&:inner_text)
  group_names.each do |name|
    get '/my' 
    click :text => name
    if page.at('html').inner_text =~ /owner:\s*testman/m
      i_puts "destroy group: #{name} #{page.uri.path}"
      click :text => '__Destroy__' # go to "Are you sure?"
      click :text => '__Destroy__' # ok
      shuld_have_content 'Group was successfully deleted.'
    else
      i_puts "#{name}: testman isn't owner."
    end
  end
end

# new group
context 'group:create' do 
  context "Name can't be blank" do
    get '/' 
    click :text => 'new group'
    page_form_with(:new_group, :group, :summary => 'summary').click_button
    shuld_be_path '/groups'
    shuld_have_content "Name can't be blank"
  end

  context "Summary can't be blank => success" do
    get '/' 
    click :text => 'new group'
    # failure
    page_form_with(:new_group, :group, :name => @group_name).click_button
    shuld_be_path '/groups'
    shuld_have_content "Summary can't be blank"
    # success
    page_form_with(:new_group, :group, :name => @group_name, :summary => 'hello').click_button
    @group_id = page.uri.path.match(%r!^/groups/(\d+)!)[1]
    shuld_be_path "/groups/#{@group_id}"
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
  shuld_be_path "/groups/#{@group_id}"
end

context 'event' do 
  context 'create' do 
    get '/my'
    click :text => @group_name
    click :text => 'new event'
    page_form_with(:new_event, :event, :title => @event_name).click_button
    shuld_be_path %r(/events/\d+)
    @event_id = page.uri.path.match(%r!^/events/(\d+)!)[1]
    shuld_have_content 'Event was successfully created.'
    shuld_have_content @event_name
    get '/my'
    shuld_have_content @event_name
  end

  context 'edit' do
    get '/my'
    click :text => @event_name
    click :text => 'Edit'
    page_form_with("edit_event_#{@event_id}", :event,
                   :limit => 5,
                   :place => 'tanemaki',
                   :address => 'yokohama',
                   :description => 'hellohello',
                   :image_url => 'images/rails.png',
                  ).click_button
    shuld_have_content 'Event was successfully updated.'
    shuld_have_content 'tanemaki'
    shuld_have_content 'yokohama'
    shuld_have_content 'hellohello'
  end

  context 'attend' do 
    get '/my'
    click :text => @event_name
    [
      %w(attend Attendance div.attendees),
      %w(absent Absence div.absentees),
      %w(maybe Maybe div.absentees), # trap: div.absentees
    ].each do |action, state, state_class|
      i_puts action
      click :text => action
      shuld_have_content state, 'div.state'
      shuld_have_content 'testman', state_class
      click :text => 'cancel'
      shuld_not_have_content 'testman', state_class
    end
  end
    
  context 'attend from group#show' do
    get '/my'
    click :text => @group_name
    %w(attend absent maybe).each do |action|
      i_puts action
      click :text => action
      click :text => 'cancel'
      shuld_not_have_content 'cancel'
    end
  end
    
  context 'attend from my' do
    get '/my'
    %w(attend absent maybe).each do |action|
      i_puts action
      click :text => action
      click :text => 'cancel'
      #shuld_not_have_content 'cancel'
    end
  end
end

context 'posts:create' do
  get '/my'
  click :text => @group_name
  click :text => 'new post'
  # post
  page_form_with(:new_post, :post, :text => 'first post').click_button
  shuld_have_content 'first post', 'div.groups_posts'
  # post again
  page_form_with(:new_post, :post, :text => 'second post').click_button
  shuld_have_content 'second post', 'div.groups_posts'
end
