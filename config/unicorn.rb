root = "/home/deployer/apps/son_of_store_engine/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.son_of_store_engine.sock"
worker_processes 1
timeout 30