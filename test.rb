# -*- encoding: utf-8 -*-
require './mytest'

setup('http://localhost:3000')

# login
get '/'
shuld_have_content 'Sign in'
get '/users/test_login'
shuld_have_content 'ok'

get '/' 
shuld_have_content 'Bu'
shuld_have_content 'Sign out(testman)'

# set English
page.link_with(:text => "English").click

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

