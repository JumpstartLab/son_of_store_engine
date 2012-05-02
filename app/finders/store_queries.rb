module StoreQueries
  def filter_by_store
    where(:store_id => store_id)
  end
end