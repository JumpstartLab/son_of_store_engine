require 'resque'

if Rails.env.production?
  # hard coded because the ENV['REDISTOGO_URL'] is incorrect at this point.
  # raise ENV.inspect for details
  redis_url = "redis://redistogo:4d634eee4cb8b2f402fb640df51703a5@drum.redistogo.com:9684/"
else
  redis_url = 'localhost:6379'
end

uri = URI.parse(redis_url)
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.redis = REDIS