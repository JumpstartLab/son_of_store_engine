# called from seeds.rb
class Seeder
  def self.build_db
    build_stores
    build_users(10000)
    build_test_accounts
    build_categories
    build_products(100000)
    build_roles
  end

  def self.at_least_two(max)
    rand(max-1)+2
  end

  def self.at_least_one(max)
    rand(max)+1
  end

  def self.build_stores
    [ "Mittenberry", "Crackberry", "Blackberry" ].each do |name|
      store = Store.create!(name: name, slug: name.downcase)
      store.slug = name.downcase
      store.status = "approved"
      store.description = Faker::Lorem.paragraph(3)
      store.save!
    end

    Store.create!(:name => "Testberry", :slug => "testberry",
                 :description => "The berriest test of them all!")
  end

  def self.build_shipping_detail
    User.all.each do |user|
      Seeder.at_least_one(2).times do
        shipping_detail = user.shipping_details.create(
          :ship_to_name => user.name,
          :ship_to_address_1 => Faker::Address.street_address,
          :ship_to_address_2 => Faker::Address.secondary_address,
          :ship_to_city => Faker::Address.city,
          :ship_to_state => Faker::Address.state, :ship_to_country => "USA",
          :ship_to_zip => Faker::Address.zip_code )
        shipping_detail.store = Store.first(:offset => rand( Store.count ))
        shipping_detail.save!
      end
    end
  end

  def self.build_orders(quantity)
    [ 'pending', 'paid', 'shipped', 'cancelled' ].each do |status_i|
      quantity.times do
        order = Seeder.generate_order
        order.order_status.update_attribute(:status, status_i)
      end
    end
  end

  def self.build_roles
    Store.all.each do |store|
      store.roles << Role.create(user: User.first(:offset => rand( User.count )), name: "store_stocker")
      store.roles << Role.create(user: User.first(:offset => rand( User.count )), name: "store_admin")
      store.roles << Role.create(user: User.first(:offset => rand( User.count )), name: "store_stocker")
      store.roles << Role.create(user: User.first(:offset => rand( User.count )), name: "store_admin")
    end
  end

  def self.generate_order
    order = Order.new
    order.user = User.first(:offset => rand( User.count ))
    order.store = Store.first(:offset => rand( Store.count ))
    Seeder.generate_order_products(order)
    Seeder.generate_shipping_details(order)
    order.save!
    order
  end

  def self.generate_shipping_details(order)
    shipping_details_for_user = order.user.shipping_details
    random_address = rand(shipping_details_for_user.size)
    order.shipping_detail = shipping_details_for_user[ random_address ]
    order
  end

  def self.generate_order_products(order)
    Seeder.at_least_one(3).times do
      product = Product.first(:offset => rand( Product.count ))
      order.order_products.build(:price => product.price,
        :product => product, :quantity => Seeder.at_least_one(3))
    end
  end

  def self.build_products(quantity)
    quantity.times do
      product = Product.create( name: "The #{Faker::Name.name}",
        description: Faker::Lorem.sentence(1),
        price: (15 + rand(10) + rand(4)*0.25) )
      product.store = Store.first(:offset => rand( Store.count ))
      store_categories = product.store.categories
      Seeder.at_least_one(2).times do
        category_to_add = store_categories[rand(store_categories.size)]
        product.add_category(category_to_add)
      end
      product.save
    end
  end

  def self.build_users(quantity)
    quantity.times do
      user = User.create( name: "#{Faker::Name.name}",
        email: "#{Faker::Internet.email}",
        password: 'password')
    end
  end

  def self.build_categories
    # should be:
    # [h,s,m].each do ...
    Store.all.each do |store|
      store.categories.create( name: 'Wool' )
      store.categories.create( name: 'Cashmere' )
      store.categories.create( name: 'Leather' )
      store.categories.create( name: 'Nylon' )
      store.categories.create( name: 'Latex' )
      store.categories.create( name: 'Cotton' )
      store.categories.create( name: 'Spandex' )
      store.categories.create( name: 'Pleather' )
      store.categories.create( name: 'Polyester' )
      store.categories.create( name: 'Crocodile' )
    end
  end

  def self.build_roles
    Store.all.each do |store|
      store.roles << Role.create(user: User.first(:offset => rand( User.count )), name: "store_admin")
      store.roles << Role.create(user: User.first(:offset => rand( User.count )), name: "store_stocker")
    end
  end

  def self.build_test_accounts
    stocker = User.create!( name: 'Matt Yoho', email: 'demo08+matt@jumpstartlab.com',
      password: 'hungry', password_confirmation: 'hungry')
    role = stocker.roles.create!(name: "store_stocker", store: Store.find(1))
    
    store_admin = User.create!( name: 'Jeff', email: 'demo08+jeff@jumpstartlab.com',
      password: 'hungry', password_confirmation: 'hungry', display_name: 'j3')
    store_admin.roles.create!(name: "store_admin", store: Store.find(2))

    admin = User.create!(name: 'Chad Fowler', display_name: 'SaxPlayer',
      email: 'demo08+chad@jumpstartlab.com', password: 'hungry', password_confirmation: 'hungry')
    admin.roles.create!(name: "site_admin")
  end

  def self.destroy_db
    User.destroy_all
    Product.destroy_all
    Category.destroy_all
    Order.destroy_all
    ShippingDetail.destroy_all
    Store.destroy_all
    Role.destroy_all
  end

end
