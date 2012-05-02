task :build_users => :environment do
  10000.times do |i|
    puts "Making user #{i}" if i % 10 == 0
    User.create(full_name: "Fancy Pants #{i}",
                email: "fancy_pants_#{i}@example.com",
                password: 'hungry',
                password_confirmation: 'hungry',
                username: "fancy#{i}")
  end
end

task :randomize_times => :environment do
  i = 0
  Order.all.each do |order|
    i += 1
    puts "Randomizing order #{i}" if i % 10 == 0
    order.update_attribute(:created_at, ((rand * 365)+1).days.ago)
  end
  i = 0
  User.all.each do |user|
    i += 1
    puts "Randomizing user #{i}" if i % 10 == 0
    user.update_attribute(:created_at, ((rand * 365)+1).days.ago)
  end
end

task :randomize_categories => :environment do
  Store.all.reject{|s| s.slug == "shoe_shop" }.each do |store|
    puts "Randomizing store #{store.name}"
    10.times do |i|
      store.categories.create!(title: "Category #{i}")
    end
    store.products.each do |product|
      ProductCategory.create!(product_id: product.id, category_id: store.categories.sample.id)
    end
  end
end
