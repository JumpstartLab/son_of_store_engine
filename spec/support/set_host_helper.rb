module SetHostHelper
  def set_host(sub)
    Capybara.default_host = "#{sub}.example.com" #for Rack::Test
    Capybara.app_host = "http://#{sub}.127localhost.com:6543"
  end
end
