module MemoryCache
  def store(key, value)
    REDIS.set(key, value)
  end

  def retrieve(key)
    REDIS.get(key)
  end
end
