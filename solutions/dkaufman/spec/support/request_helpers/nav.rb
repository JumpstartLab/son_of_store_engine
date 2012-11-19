module RequestHelpers
  module NavHelpers
    def admin_nav_go_to(link)
      find("#admin_nav").click
      find("#admin_nav_#{link.downcase}").click
    end
  end
end