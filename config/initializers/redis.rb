require 'resque'

if Rails.env.production?
  redis_url = 'redis://redistogo:5c89ed218d04538e883296814b4a08f6@drum.redistogo.com:9640/'
elsif Rails.env.development?
  redis_url = 'localhost:6379'
end
uri = URI.parse(redis_url)
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }