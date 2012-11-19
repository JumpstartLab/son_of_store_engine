namespace :load do 
  task :seed => :environment do
    Store.delete_all
    User.delete_all
    Product.delete_all

    puts "Loading 10,000 users"
    users = 10000.times.map do |n|
      User.create(:name => "User #{n}", :email => "user#{n}@foobar.com", :password => "user#{n}")
    end

    puts "Loading 40 stores"
    stores = 40.times.map do |n| 
      Fabricate(
        :store, 
        :name => "Store #{n}", 
        :slug => "store-#{n}", 
        :users => [users.sample])
    end
    
    puts "Loading 100,000 products"
    100000.times.map do |n| 
        Product.create(
            :title => "Product #{n}",
            :description => "This product #{n} rocks!",
            :price => 100,
            :retired => false,
            :store => stores.sample)
    end
  end

  task :seed_few => :environment do
    Store.delete_all
    User.delete_all
    Product.delete_all

    puts "Loading 1000 users"
    users = 1000.times.map do |n|
      User.create(:name => "User #{n}", :email => "user#{n}@foobar.com", :password => "user#{n}")
    end

    puts "Loading 40 stores"
    stores = 40.times.map do |n| 
      Fabricate(
        :store, 
        :name => "Store #{n}", 
        :slug => "store-#{n}", 
        :users => [users.sample])
    end

    puts "Loading 400 Categories"
    n = 0
    categories = stores.each.map do |store|
      n += 1
      Category.create(:name => "Category #{n}", :store => store)
    end
    
    puts "Loading 10000 products"
    10000.times.map do |n| 
        Product.create(
            :title => "Product #{n}",
            :description => "This product #{n} rocks!",
            :price => 100,
            :retired => false,
            :store => stores.sample)
    end
  end
end
