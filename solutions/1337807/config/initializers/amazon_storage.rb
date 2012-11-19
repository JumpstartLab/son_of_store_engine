if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => $PRODUCTION_CONFIG[:aws_key],       # required
      :aws_secret_access_key  => $PRODUCTION_CONFIG[:aws_secret]     # required
    }

    config.fog_directory  = 'son_of_store_engine'                     # required
    config.fog_public     = false                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end
