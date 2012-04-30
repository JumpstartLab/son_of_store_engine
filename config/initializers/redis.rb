require 'resque'

if Rails.env.production?
  # hard coded because the ENV['REDISTOGO_URL'] is incorrect at this point.
  # raise ENV.inspect for details
  redis_url = "redis://redistogo:5c89ed218d04538e883296814b4a08f6@drum.redistogo.com:9640/"
else
  redis_url = 'localhost:6379'
end

uri = URI.parse(redis_url)
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.redis = REDIS
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }