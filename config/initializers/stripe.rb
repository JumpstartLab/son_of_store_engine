STRIPE_PUBLIC_KEY = "pk_QCmP3BY5VxXSfhIRuzCPCSttyL064"

if Rails.env.production?
  Stripe.api_key = ENV['STRIPE_TOKEN']
else
  Stripe.api_key = "1234567890"
end