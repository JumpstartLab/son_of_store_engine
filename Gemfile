source 'https://rubygems.org'

gem 'rails', '3.2.3'
gem 'jquery-rails'
gem 'devise'
gem 'cancan'
gem 'bcrypt-ruby'
gem 'heroku'
gem 'slim'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.0.2'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'rack-perftools_profiler', :require => 'rack/perftools_profiler'
  gem 'perftools.rb'
  gem 'newrelic_rpm'
  gem 'taps'
  gem 'pg'
  gem 'fabrication'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'guard'
  gem 'growl'
  gem 'guard-rspec'
  gem 'faker'
  gem 'seed_dump'
  gem 'tailor', '0.1.5'
  gem 'cane'
  gem 'simplecov', :require => false
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'reek', :git => 'git://github.com/mvz/reek.git', :branch =>
  'ripper_ruby_parser-2'
  gem 'ripper_ruby_parser'
end
