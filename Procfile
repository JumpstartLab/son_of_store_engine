web:     bundle exec rails server -p $PORT
worker: VERBOSE=TRUE QUEUE=* bundle exec rake environment resque:work 
worker: VERBOSE=TRUE QUEUE=* bundle exec rake environment resque:scheduler
