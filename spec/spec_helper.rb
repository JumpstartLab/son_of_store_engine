# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.before(:suite) do
    FactoryGirl.create(:user,
      :name => "Horace Worace",
      :email => "horace@foo.com",
      :display_name => "horace_worace",
      :password => "foobar",
      :password_confirmation => "foobar")

    FactoryGirl.create(:user,
      :name => "Harold",
      :email => "harold@foo.com",
      :display_name => "harold_harold",
      :password => "foobar",
      :password_confirmation => "foobar")

    FactoryGirl.create(:store,
      :name => "Test Store",
      :url_name => "test-store",
      :description => "errday im testin",
      :approved => true,
      :enabled => true,
      :owner_id => User.find_by_name("Horace Worace").id)

    FactoryGirl.create(:store,
      :name => "Best Sunglasses",
      :url_name => "best-sunglasses",
      :description => "errday im testin",
      :approved => true,
      :enabled => true,
      :owner_id => User.all[-2].id)

    FactoryGirl.create(:store, 
      :name => "Stupid Store",
      :url_name => "stupid-store",
      :description => "errday im testin too",
      :approved => nil,
      :enabled => false,
      :owner_id => User.all[-2].id)

  end

  #config.after(:suite) { Rake::Task['db:purge'].invoke }
  config.after(:suite) do 
    User.destroy_all 
    Store.destroy_all
  end

  #stop tests when one fails
  # config.fail_fast = true 


  #by default will run only focused specs - hw
  #config.filter_run :focus => true
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.include SetHostHelper
  config.include LoginUser
  config.include Rails.application.routes.url_helpers
  config.include ExampleData::Projects
  config.include Sorcery::TestHelpers::Rails
  config.include StoreSetup
  ActiveSupport::Deprecation.silenced = true
end

module Sorcery
  module TestHelpers
    module Rails
      def login_user_post(user, password)
        page.driver.post(sessions_url, { email: user, password: password, remember_me: false})
      end
    end
  end
end

#module SetHostHelper
  #def set_host(sub)
    #Capybara.default_host = "#{sub}.example.com" #for Rack::Test
    #Capybara.app_host = "http://#{sub}.127localhost.com:6543"
  #end
#end

Capybara.server_port = 6543
