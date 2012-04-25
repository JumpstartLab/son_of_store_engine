## StoreEngine

http://tutorials.jumpstartlab.com/projects/store_engine.html

## To setup:

Install ImageMagick (not a gem!)

  brew install imagemagick

Then set up the dbs and seed

  rake db:migrate db:test:prepare
  rake db:seed

Set up your stripe secret key. Create a file `config/initializers/stripe_secret_key.rb' with the contents:

  Stripe.api_key ="KEY_FROM_EMAIL"

Use POW

  curl get.pow.cx | sh
  cd ~/.pow
  ln -s /path/to/myapp son.dev