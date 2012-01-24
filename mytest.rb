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
end

def page
  @agent.page
end

def body
  page.body
end

def have_content?(str, tag = nil)
  text = tag ? page.at(tag).inner_text : page.body
  text.toutf8.include?(str.toutf8)
end

def shuld_have_content(str, tag = nil)
  have_content?(str, tag) ? success : failure
end

def shuld_not_have_content(str, tag = nil)
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
