# guest user model
class GuestUser < User
  authenticates_with_sorcery!

end
