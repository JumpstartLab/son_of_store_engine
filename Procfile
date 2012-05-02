web:     bundle exec rails server -p $PORT
worker: VERBOSE=TRUE QUEUE=* bundle exec rake environment resque:work 
scheduler: VERBOSE=TRUE QUEUE=* bundle exec rake environment resque:scheduler
