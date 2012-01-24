require 'mechanize'

def setup(urlbase)
  @agent = Mechanize.new
  @urlbase = urlbase
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

def shuld_have_content(str)
  cond = page.body.include?(str)
  cond ? success : failure
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
