module LoginUser
  def login_user(email, password="foobar")
    visit "/sessions/new"
    fill_in "email", with: email
    fill_in "password", with: password
    click_link_or_button('Log in')
  end
end

