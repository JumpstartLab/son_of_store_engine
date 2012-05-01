require 'resque'
# Resque.redis = 'localhost:6379:1/myns'
#
ENV["REDISTOGO_URL"] ||= "redis://redistogo:c71b799caebdb4d597de7487a2aac7dd@herring.redistogo.com:9910/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

