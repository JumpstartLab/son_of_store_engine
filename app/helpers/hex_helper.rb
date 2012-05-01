module HexHelper
  def create_hex
    Digest::SHA1.hexdigest(%Q|#{ Time.now.to_i.to_s + rand(10000).to_s }|)
  end
end