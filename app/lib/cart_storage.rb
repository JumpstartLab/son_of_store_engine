# extact cart storage
class CartStorage
  attr_reader :session

  def initialize(session)
    @session = session
  end

  def [](store_id)
    carts = get_hash_from_session
    carts[store_id]
  end

  def keys
    get_hash_from_session.keys
  end

  def values
    get_hash_from_session.values
  end

  def []=(store_id, cart_id)
    carts = get_hash_from_session
    carts[store_id] = cart_id
    store_hash_in_session(carts)
  end

  private

  def get_hash_from_session
    if session[:carts].blank?
      {}
    else
      YAML.load(session[:carts]) rescue {}
    end
  end

  def store_hash_in_session(hash)
    session[:carts] = hash.to_yaml
  end
end
