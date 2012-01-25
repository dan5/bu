require 'mechanize'

def setup(urlbase)
  @agent = Mechanize.new
  @urlbase = urlbase
  yield if block_given?
end

def context(name)
  yield if block_given?
end

def get(path)
  @agent.get(@urlbase + path)
  shuld_not_have_content('Error')
end

def click(*args)
  page.link_with(*args).click
  shuld_not_have_content('Error')
end

def page
  @agent.page
end

def body
  page.body
end

def have_content?(str, tag)
  page.at(tag).inner_text.toutf8.include?(str.toutf8)
end

def shuld_have_content(str, tag = :html)
  have_content?(str, tag) ? success : failure
end

def shuld_not_have_content(str, tag = :html)
  have_content?(str, tag) ? failure : success
end

def assert(cond, msg = nil)
  cond ? success : failure
end

def success
  puts 'pass'
end

def failure(depth = 1)
  puts "failure: #{caller[depth]}"
end
