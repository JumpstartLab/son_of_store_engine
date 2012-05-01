`whoami >> ~/debugging.log`
`echo $HOST >> ~/debugging.log`
`echo $SENDGRID_USERNAME >> ~/debugging.log`
`echo $SENDGRID_PASSWORD >> ~/debugging.log`

if ENV['HOST'] == 'sonofstoreengine'
  ActionMailer::Base.smtp_settings = {
    :address              => '127.0.0.1',
    :port                 => '25',
    :domain               => 'sonofstoreengine.com',
    :enable_starttls_auto => false
  }
else
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'
  }
end

delivery_method = if Rails.env.production?
                    :smtp
                  else
                    :test
                  end

ActionMailer::Base.delivery_method = delivery_method
ActionMailer::Base.default_url_options[:host] = 'sonofstoreengine.com'
