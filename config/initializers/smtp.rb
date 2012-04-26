ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => ENV['GMAIL_SMTP_DOMAIN'],
  :user_name            => ENV['GMAIL_SMTP_USER'],
  :password             => ENV['GMAIL_SMTP_PASSWORD'],
  :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options[:host] = 'sonofstoreengine.com'
