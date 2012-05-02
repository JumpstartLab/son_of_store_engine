class Seeder

  def self.build_mega_db
    build_users(10000)
    build_stores
    build_products(34000, 1)
    build_products(34000, 2)
    build_products(34000, 3)
    build_categories
    build_shipping_detail
    build_credit_cards
    build_orders
  end

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

  def self.build_credit_cards
    User.all.each do |user|
      user.credit_cards.create(:credit_card_type => "Visa",
                               :last_four => "4242",
                               :exp_month => "05",
                               :exp_year => "15",
                               :stripe_customer_token => "tok_KM1feeMHDhSgiq",
                               :default_card => false)
    end
  end

  def self.build_shipping_detail
    User.all.each do |user|
      2.times do
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
      30.times do
        order = Seeder.generate_order
        order.order_status.update_attribute(:status, status_i)
      end
    end
  end

  def self.generate_order
    order = Order.new
    order.user = User.all.sample
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
    4.times do
      product = Product.all.sample
      order.order_products.build(:price => product.price,
        :product => product, :quantity => rand(3)+1)
    end
  end

  def self.build_products(quantity, store_id)
    quantity.times do
      product = Product.create( name: "#{Faker::Name.name}",
        description: Faker::Lorem.sentences(2),
        price: (15 + rand(10) + rand(4)*0.25),
        photo: Seeder.photo_url.sample,
        store_id: store_id )
      (rand(3)).times do
        product.add_category(product.store.categories.sample)
      end
    end
  end

  def self.build_categories
    # should be:
    # [h,s,m].each do ...
    Category.create( name: 'Belle', store_id: 1 )
    Category.create( name: 'Bonhomme', store_id: 1 )
    Category.create( name: 'Taxidermy', store_id: 1 )
    Category.create( name: 'Meat', store_id: 1 )
    Category.create( name: 'Paris', store_id: 2 )
    Category.create( name: 'Joie de Vivre', store_id: 2 )
    Category.create( name: 'Terraria', store_id: 2 )
    Category.create( name: 'Sled-dogs', store_id: 2 )
    Category.create( name: 'Coats', store_id: 3 )
    Category.create( name: 'Jackets', store_id: 3 )
    Category.create( name: 'Badgers', store_id: 3 )
    Category.create( name: 'Conveyance', store_id: 3 )
  end

  def self.build_stores
    Store.create( name: "Best Sunglasses", url_name: "best-sunglasses",
      description: "Buy our sunglasses!", owner_id: 1)
    Store.create( name: "Worace's Workshop", url_name: "woraces-workshop",
      description: "Wonderful wares whenever Worace wants!", owner_id: 2)
    Store.create( name: "Pierre's Kitchen", url_name: "pierres-kitchen",
      description: "They sure are comfortable!", owner_id: 3)
  end

  def self.build_users(num=0)
    User.create( name: 'Matt Yoho', email: 'demo08+matt@jumpstartlab.com',
      password: 'hungry')
    User.create( name: 'Jeff', display_name: 'j3',
      email: 'demo08+jeff@jumpstartlab.com', password: 'hungry')
    admin = User.create( name: 'Chad Fowler', display_name: 'SaxPlayer',
      email: 'demo08+chad@jumpstartlab.com', password: 'hungry')
    admin.update_attribute(:admin, true)
    @users = num.times.map do |n|
      FactoryGirl.create(:user, :name => "User #{n}", :email => "user#{n}@chez-pierre.info", :password => "hungry", :password_confirmation => "hungry")
    end
  end

  def self.destroy_db
    User.destroy_all
    Product.destroy_all
    Category.destroy_all
    Order.destroy_all
    ShippingDetail.destroy_all
  end

  def self.photo_url
    ["http://s3.amazonaws.com/static.fab.com/product/125149-300x300-1335384095-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125146-300x300-1335391068-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125141-300x300-1335383975-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125142-300x300-1335390858-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125140-300x300-1335383963-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125138-300x300-1335390939-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125136-300x300-1335383994-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125135-300x300-1335384248-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125211-300x300-1335384139-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125206-300x300-1335390228-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125204-300x300-1335384163-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125199-300x300-1335384026-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125198-300x300-1335384045-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125195-300x300-1335383991-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125192-300x300-1335384172-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125190-300x300-1335384190-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125189-300x300-1335389943-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125187-300x300-1335389901-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125186-300x300-1335389866-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125178-300x300-1335389573-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125176-300x300-1335383954-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125173-300x300-1335384218-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125172-300x300-1335383966-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125169-300x300-1335384041-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125167-300x300-1335389409-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125158-300x300-1335384196-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125156-300x300-1335383960-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125155-300x300-1335384023-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/125171-300x300-1335384157-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/100617-300x300-1335459351-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/122389-300x300-1335454040-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/85154-300x300-1331153250-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/126868-300x300-1335480013-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/126848-300x300-1335478036-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/124837-300x300-1335540216-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/7259-300x300-1312986784-primary.png",
      "http://s3.amazonaws.com/static.fab.com/product/114082-300x300-1334237411-primary.png",
    ]
  end

end
