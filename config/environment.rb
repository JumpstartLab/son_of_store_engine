# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
StoreEngine::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :address  => "smtp.someserver.net",
  :port  => 25,
  :user_name  => "hungryopensource",
  :password  => "hungryacademy",
  :authentication  => :login
}