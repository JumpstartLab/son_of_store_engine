module LoginUser
  def login_user(email, password)
    visit siginin_path
    fill_in "email", with: email
    fill_in "password", with: password
    click_link_or_button('log in')
  end
end

