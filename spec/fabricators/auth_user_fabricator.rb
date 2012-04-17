Fabricator(:auth_user, :class_name => "User") do
  id { sequence }
  password { "admin" }
  name { "Admin Boom"}
  is_admin { true }
  email { "whatever@whatever.com" }
  salt { "asdasdastr4325234324sdfds" }
  crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt("secret", 
                     "asdasdastr4325234324sdfds") }
end