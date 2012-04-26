StoreEngine::Application.configure do

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true


  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  ActionMailer::Base.smtp_settings = {
    :address => 'smtp.gmail.com',
    :port => 587,
    :domain => 'gmail.com',
    :authentication => :plain,
    :user_name => 'hungry.store.engine@gmail.com',
    :password => 'paulgraham',
    :enable_starttls_auto => true
  }
end
