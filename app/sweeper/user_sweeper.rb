class UserSweeper < ActionController::Caching::Sweeper
  observe User

  def sweep(user)
    expire_fragment("users_index_page")
    expire_fragment("admin_users_index_page")
  end
  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end