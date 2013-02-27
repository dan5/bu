source 'http://rubygems.org'

# hack to make heroku cedar not install special groups
# http://soupmatt.com/fixing-bundlewithout-on-heroku-cedar

def hg(g)
  (ENV['HOME'].gsub('/','') == 'app' ? :test : g)
end

gem 'rails', '3.2.12'

group :preview do
  gem 'pg'
  gem 'thin'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.1'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'configatron'
gem 'jquery-rails'
gem 'haml-rails'
gem 'execjs'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'hikidoc'

group hg(:production) do
  gem 'sqlite3'
end

group :test, :development do
  gem 'sqlite3'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rails_best_practices', '>= 1.2.0', :require => false
  gem 'database_cleaner'
  gem 'forgery'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-coolline'
  gem 'capybara'
  gem 'launchy'
  gem 'headless'
  gem 'shoulda-matchers', :git => 'git://github.com/thoughtbot/shoulda-matchers.git', :ref => 'fd4aa5'
  gem 'simplecov', require: false
  gem 'heroq', :git => 'git://github.com/1syo/heroq.git', :tag => 'v0.0.1'
  #gem 'rails-erd'
end
