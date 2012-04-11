# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
StoreEngine::Application.initialize!

Bitly.use_api_version_3
BITLY = Bitly.new('dkaufman16', 'R_93a76875d901c6d76064f30a298f2791')
