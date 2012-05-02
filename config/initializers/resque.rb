require 'resque'
require 'resque/server'

Resque.redis = 'localhost:6379:1/myns'