require 'resque/tasks'

task "resque:setup" => :environment do
    ENV['QUEUE'] = '*'
end

desc "store_engine_mailer"
task "jobs:work" => "resque:work"
