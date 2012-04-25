ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => ENV['GMAIL_SMTP_DOMAIN'],
  :user_name            => ENV['GMAIL_SMTP_USER'],
  :password             => ENV['GMAIL_SMTP_PASSWORD'],
  :authentication       => "login",
  :enable_starttls_auto => true
}

# host = if Rails.env.development?
#   Mail.register_interceptor(DevelopmentMailInterceptor)
#   'localhost:3000'
# else
#   'sonofstoreengine.com'
# end

ActionMailer::Base.default_url_options[:host] = 'sonofstoreengine.com'
