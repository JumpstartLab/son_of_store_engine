require 'resque'

ENV["redis://dariver1:b5cb61b99299685e5cefd9e38f7545e2@panga.redistogo.com:9005/"] ||= "redis://dariver1:cavalier@host:1234/"

uri = URI.parse(ENV["redis://dariver1:b5cb61b99299685e5cefd9e38f7545e2@panga.redistogo.com:9005/"])

Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

Dir["/app/jobs/*.rb"].each { |file| require file }