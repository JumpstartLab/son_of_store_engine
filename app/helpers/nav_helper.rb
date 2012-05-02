module NavHelper

  def main_navigation
    if request.subdomain.empty?
      if current_user
        nav_array_home_user
      else
        nav_array_home_guest
      end
    elsif current_user && current_user.admin?
      nav_array_admin
    elsif current_user
      nav_array_user
    else
      nav_guest
    end
  end

  def nav_array_home_user
    { 
      "View/Edit Profile" => profile_path,      
      "Logout" => logout_path,
    }
  end

  def nav_array_home_guest
    { 
      "Login or Signup" => login_path
    }
  end

  def nav_array_admin
    {
      "Admin Dashboard" => admin_dashboard_path,
      "#{current_tenant.name} Cart (#{@cart.products.size if @cart})" => cart_path,
      "#{current_tenant.name} Orders" => my_orders_orders_path,
      "Profile" => profile_path,
      "Logout" => logout_path
    }
  end

  def nav_array_user
    {
      "#{current_tenant.name} Cart (#{@cart.products.size if @cart})" => cart_path,
      "#{current_tenant.name} Orders" => my_orders_orders_path,
      "Profile" => profile_path,
      "Logout" => logout_path
    }
  end

  def nav_guest
    {
      "#{current_tenant.name} Products" => root_path,
      "#{current_tenant.name} Cart (#{@cart.products.size if @cart})" => cart_path,
      "Login or Signup" => login_path
    }
  end

  def admin_navigation
    {
      "Products"    => admin_products_path,
      "Orders"      => admin_orders_path,
      "Categories"  => admin_categories_path,
      "Users"       => admin_users_path,
    }
  end
end