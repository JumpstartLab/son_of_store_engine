require 'resque'
# Resque.redis = 'localhost:6379:1/myns'

ENV["REDISTOGO_URL"] ||= "redis://redistogo:c34b42ca9e80280e71fe72bb3a3800a8@herring.redistogo.com:9917/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
