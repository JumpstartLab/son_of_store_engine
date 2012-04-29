require 'resque/tasks'

task "resque:setup" => :environment do
    ENV['QUEUE'] = 'store_engine_mailer'
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
