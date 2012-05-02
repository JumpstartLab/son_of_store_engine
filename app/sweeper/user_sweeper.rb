class UserSweeper < ActionController::Caching::Sweeper
  observe User

  def sweep(user)
    expire_fragment("user_index_with_id_#{user.id}")
    expire_fragment("admin_user_index_with_id_#{user.id}")
  end
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end