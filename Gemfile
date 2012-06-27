source 'http://rubygems.org'

gem 'rails', '3.2.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.1'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem "haml-rails"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


gem 'execjs'
gem 'therubyracer'
gem 'omniauth'
gem 'omniauth-twitter'


group :test, :development do
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem "rspec-rails"
  gem 'rails_best_practices', ">= 1.2.0", :require => false
  gem "database_cleaner"
  gem 'forgery'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-coolline'
  gem 'guard'
  gem 'guard-rails'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-livereload'
  group :darwin do
    gem 'growl'
    gem 'rb-fsevent'
  end
  gem 'named_let'
end

group :test do
  gem "capybara"
  gem "launchy"
  gem 'capybara-webkit'
  gem 'headless'
  gem 'spork', '~> 0.9.0.rc'
  # TODO Bundling from repo to use set_the_flash matcher with key.
  #      Use released ver. when next version is released.
  gem "shoulda-matchers", :git => 'git://github.com/thoughtbot/shoulda-matchers.git', :ref => 'fd4aa5'
end
