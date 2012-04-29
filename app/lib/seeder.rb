class Seeder
  def self.build_db
    build_stores
    build_users
    build_shipping_detail
    build_categories
    build_products(50)
    build_orders(100)
  end

  def self.at_least_two(max)
    rand(max-1)+2
  end

  def self.at_least_one(max)
    rand(max)+1
  end

  def self.build_stores
    [ "Mittenberry", "Crackberry", "Blackberry" ].each do |name|
      store = Store.create(:name => name)
      store.slug = name.downcase
      store.status = "approved"
      store.description = Faker::Lorem.paragraph(3)
      store.save
    end

    Store.create(:name => "Testberry", :slug => "testberry",
                 :description => "The berriest test of them all!")
  end

  def self.build_shipping_detail
    User.all.each do |user|
      Seeder.at_least_one(2).times do
        shipping_detail = user.shipping_details.create( :ship_to_name => user.name,
          :ship_to_address_1 => Faker::Address.street_address,
          :ship_to_address_2 => Faker::Address.secondary_address,
          :ship_to_city => Faker::Address.city,
          :ship_to_state => Faker::Address.state, :ship_to_country => "USA",
          :ship_to_zip => Faker::Address.zip_code )
        shipping_detail.store = Store.first(:offset => rand( Store.count ))
        shipping_detail.save
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

  def self.generate_order
    order = Order.new
    order.user = User.first(:offset => rand( User.count ))
    order.store = Store.first(:offset => rand( Store.count ))
    Seeder.generate_order_products(order)
    Seeder.generate_shipping_details(order)
    order.save
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
        description: Faker::Lorem.paragraph(3),
        price: (15 + rand(10) + rand(4)*0.25) )
      (rand(3) + 1).times do
        offset = rand(Category.count)
        product.add_category(Category.first(:offset => offset))
        product.store = Store.first(:offset => rand( Store.count ))
        product.save
      end
    end
  end

  def self.build_categories
    # should be:
    # [h,s,m].each do ...
    Store.all.each do |store|
      store.categories.create( name: 'Category 1' )
      store.categories.create( name: 'Category 2' )
      store.categories.create( name: 'Category 3' )
      store.categories.create( name: 'Category 4' )
      store.categories.create( name: 'Category 5' )
    end
  end

  def self.build_users
    User.create( name: 'Matt Yoho', email: 'demo08+matt@jumpstartlab.com',
      password: 'hungry')
    User.create( name: 'Jeff', display_name: 'j3',
      email: 'demo08+jeff@jumpstartlab.com', password: 'hungry')
    admin = User.create( name: 'Chad Fowler', display_name: 'SaxPlayer',
      email: 'demo08+chad@jumpstartlab.com', password: 'hungry')
    admin.update_attribute(:site_admin, true)
  end

  def self.destroy_db
    User.destroy_all
    Product.destroy_all
    Category.destroy_all
    Order.destroy_all
    ShippingDetail.destroy_all
  end

end
