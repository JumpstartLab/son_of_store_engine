module StoreSetup
  def create_store
    s=Store.new(name: "test", url_name: "test", description: "a test store")
    s.approved = true
    s.enabled = true
    s.save!
  end
end