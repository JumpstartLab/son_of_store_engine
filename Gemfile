source 'https://rubygems.org'

gem 'addressable'
gem 'bcrypt-ruby', '3.0.1'
gem 'bootstrap-sass', '2.0.0'
gem 'cancan'
gem 'decent_exposure'
gem 'dynamic_form'
gem 'faker'
gem 'jquery-rails'
gem 'money-rails'
gem 'rails', '3.2.3'
gem 'rake'
gem 'resque'
gem 'slim'
gem 'sorcery'
gem 'stripe'
gem 'twilio-ruby'

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails',   '~> 3.2.3'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'cane', :git => "git://github.com/square/cane.git"
  gem 'capybara'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 3.1.0'
  gem 'growl'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'redis-store', '~>1.0.0'
  gem 'reek', :git => "git://github.com/mvz/reek.git", :branch => "ripper_ruby_parser-2"
  gem 'rspec-rails'
  #gem 'ruby-debug19', :require => 'ruby_debug'
  gem 'simplecov'
  gem 'sqlite3'
end