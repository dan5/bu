source 'http://rubygems.org'

gem 'rails', '3.2.11'

group :development, :test, :production do
  gem 'sqlite3'
end
group :preview do
  gem 'pg'
  gem 'thin'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.1'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'haml-rails'
gem 'execjs'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'hikidoc'

group :test, :development do
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'rspec-rails', '2.12.0'
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
  #gem 'rails-erd'
end
