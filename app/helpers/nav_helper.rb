module NavHelper

  def main_navigation
    if request.subdomain.empty?
      nav_array_home
    elsif current_user && current_user.admin?
      nav_array_admin
    elsif current_user
      nav_array_user
    else
      nav_guest
    end
  end

  def nav_array_home
    { 
      "Welcome!" => root_path
    }  
  end

  def nav_array_admin
    {
      "Home" => root_path,
      "Sales" => sales_path,
      "Dashboard" => store_admin_dashboard_path,
      "My Orders" => my_orders_orders_path,
      "Logout" => logout_path
    }
  end

  def nav_array_user
    {
      "Home" => root_path,
      "Sales" => sales_path,
      "My Orders" => my_orders_orders_path,
      "Logout" => logout_path
    }
  end

  def nav_guest
    {
      "Home" => root_path,
      "Sales" => sales_path,
      "Login or Signup" => login_path
    }
  end

  def store_admin_navigation
    {
      "Products"    => store_admin_products_path,
      "Orders"      => store_admin_orders_path,
      "Categories"  => store_admin_categories_path,
      "Users"       => store_admin_users_path,
      "Sales"       => store_admin_sales_path
    }
  end
end