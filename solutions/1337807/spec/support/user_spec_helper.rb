module UserHelper
  def fill_product_form
    product = Fabricate.build(:product)

    fill_in "Title", :with => product[:title]
    fill_in "Description", :with => product[:description]
    fill_in "Price", :with => product[:price]
    fill_in "Photo", :with => product[:photo]
  end

  def create_user(user)
    visit new_user_registration_path
    complete_user_form(user)
    click_button "Sign up"
  end

  def complete_user_form(user)
    fill_in "Name", :with => user.name
    fill_in "Username", :with => user.username
    fill_in "Email", :with => user.email
    fill_in "Password",
      :with => Fabricate.attributes_for(:user)[:password]
    fill_in "Password confirmation",
      :with => Fabricate.attributes_for(:user)[:password]
  end

  def login_as(user)
    visit new_user_session_path

    fill_in "Email", :with => user.email
    fill_in "Password", :with => Fabricate.attributes_for(:user)[:password]

    click_button "Log In"
  end

  def login_as_admin(user)
    role = Role.create(:name => 'admin')
    user.roles << role
    login_as(user)
  end

  def login_as_superadmin(user)
    role = Role.create(:name => 'super_admin')
    user.roles << role
    login_as(user)
  end

  def fill_billing_form
    billing = build_billing
    fill_in "Credit card number", :with => billing[:credit_card_number]
    fill_in "Cvc", :with => billing[:cvc]
    fill_in "Expiration date", :with => billing[:expiration_date]
    fill_billing_address(billing[:address])
    fill_shipping_address(billing[:address])
  end

  def fill_billing_address(address)
    fill_in "Street", :with => address[:street]
    fill_in "City", :with => address[:city]
    fill_in "State", :with => address[:state]
    fill_in "Zipcode", :with => address[:zipcode]
  end

  def fill_shipping_address(address)
    fill_in "Street", :with => address[:street]
    fill_in "City", :with => address[:city]
    fill_in "State", :with => address[:state]
    fill_in "Zipcode", :with => address[:zipcode]
  end

  def build_billing
    {
      :credit_card_number => "1234123412341234",
      :cvc => "123",
      :expiration_date => "04/15",
      :address => {
        :street => "123 Jonan Street",
        :city => "Jonanville",
        :state => "MD",
        :zipcode => "12345"
      }
    }
  end
end
