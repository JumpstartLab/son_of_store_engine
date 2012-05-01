if ENV['HOST'] == 'sonofstoreengine'
  delivery_method = :sendmail
else
  delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'
  }
end

delivery_method = :test if Rails.env.test?

ActionMailer::Base.delivery_method = delivery_method
ActionMailer::Base.default_url_options[:host] = 'sonofstoreengine.com'
