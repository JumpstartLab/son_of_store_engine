if Rails.env.production?
  require 'resque'
  redis_url = "redis://dariver1:b5cb61b99299685e5cefd9e38f7545e2@panga.redistogo.com:9005/"
  uri = URI.parse(redis_url)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Resque.redis = REDIS
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
elsif Rails.env.development?
  require 'resque'
  redis_url = 'localhost:6379'
  uri = URI.parse(redis_url)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Resque.redis = REDIS
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
end