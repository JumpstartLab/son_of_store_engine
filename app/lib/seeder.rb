class Seeder

  def self.build_db
    build_users
    build_stores
    build_shipping_detail
    build_categories
    build_products(20, 1)
    build_products(20, 2)
    build_products(20, 3)
    build_orders
  end

  def self.at_least_two(max)
    rand(max-1)+2
  end

  def self.at_least_one(max)
    rand(max)+1
  end

  def self.build_shipping_detail
    User.all.each do |user|
      Seeder.at_least_one(2).times do
        user.shipping_details.create( :ship_to_name => user.name,
          :ship_to_address_1 => Faker::Address.street_address,
          :ship_to_address_2 => Faker::Address.secondary_address,
          :ship_to_city => Faker::Address.city,
          :ship_to_state => Faker::Address.state, :ship_to_country => "USA",
          :ship_to_zip => Faker::Address.zip_code )
      end
    end
  end

  def self.build_orders
    [ 'pending', 'paid', 'shipped', 'cancelled' ].each do |status_i|
      Seeder.at_least_two(4).times do
        order = Seeder.generate_order
        order.order_status.update_attribute(:status, status_i)
      end
    end
  end

  def self.generate_order
    order = Order.new
    order.user = User.first(:offset => rand( User.count ))
    Seeder.generate_order_products(order)
    order.save
    Seeder.generate_shipping_details(order)
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

  def self.build_products(quantity, store_id)
    quantity.times do
      product = Product.create( name: "The #{Faker::Name.name}",
        description: Faker::Lorem.sentences(2),
        price: (15 + rand(10) + rand(4)*0.25),
        store_id: store_id )
      (rand(3) + 1).times do
        offset = rand(Category.count)
        product.add_category(Category.first(:offset => offset))
      end
    end
  end

  def self.build_categories
    # should be:
    # [h,s,m].each do ...
    Category.create( name: 'Hats', store_id: 1 )
    Category.create( name: 'Scarves', store_id: 1 )
    Category.create( name: 'Mittens', store_id: 2 )
    Category.create( name: 'Boots', store_id: 2 )
    Category.create( name: 'Coats', store_id: 3 )
    Category.create( name: 'Jackets', store_id: 3 )
  end

  def self.build_stores
    Store.create( name: "Best Sunglasses", url_name: "best-sunglasses",
      description: "Buy our sunglasses!", owner_id: 1)
    Store.create( name: "Worace's Workshop", url_name: "woraces-workshop",
      description: "Wonderful wares whenever Worace wants!", owner_id: 2)
    Store.create( name: "Matt's Mumus", url_name: "matts-mumus",
      description: "They sure are comfortable!", owner_id: 3)
  end

  def self.build_users
    User.create( name: 'Matt Yoho', email: 'demo08+matt@jumpstartlab.com',
      password: 'hungry')
    User.create( name: 'Jeff', display_name: 'j3',
      email: 'demo08+jeff@jumpstartlab.com', password: 'hungry')
    admin = User.create( name: 'Chad Fowler', display_name: 'SaxPlayer',
      email: 'demo08+chad@jumpstartlab.com', password: 'hungry')
    admin.update_attribute(:admin, true)
  end

  def self.destroy_db
    User.destroy_all
    Product.destroy_all
    Category.destroy_all
    Order.destroy_all
    ShippingDetail.destroy_all
  end

end