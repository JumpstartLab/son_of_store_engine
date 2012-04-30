Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

if Rails.env.production? || Rails.env.development?
  ENV["REDISTOGO_URL"] ||= 'redis://redistogo:5c89ed218d04538e883296814b4a08f6@drum.redistogo.com:9640/'

  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
end