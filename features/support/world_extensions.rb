require 'addressable/uri'

module WorldExtensions
  def login(user)
    visit('/signin')
    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password)
    click_on('Log in')

    user
  end

  def login_as_site_admin
    user = FactoryGirl.create(:site_admin)
    login(user)
  end

  def current_store
    slug = current_path.split("/").first
    Store.where(slug: slug).first
  end

  def slug_for(name)
    Store.where(name: name).first.slug
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
