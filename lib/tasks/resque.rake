require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*' 
  ENV['VERBOSE'] = true
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"