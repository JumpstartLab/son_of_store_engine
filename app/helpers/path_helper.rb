module PathHelper
  private
    def smart_signin_path
      current_store ? store_signin_path : signin_path
    end

    def smart_signout_path
      current_store ? store_signout_path : signout_path
    end

    def smart_new_user_path
      current_store ? new_store_user_path : new_user_path
    end

    def smart_store_sessions_path
      current_store ? store_sessions_path(current_store.slug) : sessions_path
    end
end