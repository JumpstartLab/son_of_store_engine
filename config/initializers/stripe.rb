STRIPE_PUBLIC_KEY = "pk_QCmP3BY5VxXSfhIRuzCPCSttyL064"

Stripe.api_key = ENV['STRIPE_TOKEN'] if Rails.env.production?