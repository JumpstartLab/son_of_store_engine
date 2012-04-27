require 'resque'

redis_url = ENV["REDISTOGO_URL"] || 'localhost:6379'
uri = URI.parse(redis_url)
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.redis = REDIS