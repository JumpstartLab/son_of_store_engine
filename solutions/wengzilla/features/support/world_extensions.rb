require 'addressable/uri'

module WorldExtensions
  def log_in(user)
    # XXX This sucks.
    click_on('Sign in') rescue visit('/signin')
    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password)
    click_on('Log in')
    user
  end

  def log_in_as_site_admin
    user = FactoryGirl.create(:site_admin)
    log_in(user)
  end

  def log_in_as_store_admin
    user = FactoryGirl.create(:store_admin)
    log_in(user)
  end

  def log_in_as_store_stocker(store)
    user = FactoryGirl.create(:store_stocker, store: store)
    log_in(user)
  end

  def slug_for(name)
    Store.where(name: name).first.slug
  end

  def add_items_to_cart(num = 10)
    products = Product.where(store_id: current_store.id).limit(num).to_a
    products = (0..num).map do |n|
      products[products.count % n+1]
    end

  end

  def visit_store(name)
    visit store_path(slug_for(name))
  end

  def flash_text
    find(".alert").text
  end

  def status_code
    if page.driver.class.name == "Capybara::RackTest::Driver"
      page.driver.response.status
    else
      raise "#status_code is not implemented for this driver: #{page.driver.class.name}"
    end
  end
end

World(WorldExtensions)
