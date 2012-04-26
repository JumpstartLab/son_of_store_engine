ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => 'heroku.com'
}
delivery_method = if Rails.env.production?
                    :smtp
                  else
                    :test
                  end
ActionMailer::Base.delivery_method = delivery_method
ActionMailer::Base.default_url_options[:host] = 'sonofstoreengine.com'
