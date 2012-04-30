# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

[Store, Product, Order, Cart, User, Address, Category, Privilege, VisitorUser].each do |model|
  puts "Clearing #{model.to_s}"
  model.destroy_all
end

first_store_owner = User.create(  full_name: "Mark T",
              password: "hungry",
              password_confirmation: "hungry",
              email: "mark.tabler@livingsocial.com",
              username: "capncurry" )

second_store_owner = User.create(  full_name: "Tom K",
              password: "hungry",
              password_confirmation: "hungry",
              email: "tom.kiefhaber@livingsocial.com",
              username: "Git Master" )

first_store = Store.new(name: "Shoe Shop", slug:"shoe_shop", description: "Buy some shoes!!!!")
first_store.update_attribute(:owner_id, first_store_owner.id)
first_store.update_attribute(:status, "enabled")
first_store.save!

second_store = Store.new(name: "Crapola Shop", slug:"crapola_shop", description: "Lorem ipsum crapola sit amet")
second_store.update_attribute(:owner_id, second_store_owner.id)
second_store.update_attribute(:status, "enabled")
second_store.save!

male_category = first_store.categories.create( title: "Male")
female_category = first_store.categories.create( title: "Female")
casual_category = first_store.categories.create( title: "Casual")
dress_category = first_store.categories.create( title: "Dress")
wtf_category = first_store.categories.create( title: "WTF")
boot_category = first_store.categories.create( title: "Boot")

def seed_products(store, count)
  count.times do |i| 
    puts "Seeding product #{i}"
    title = Faker::Lorem.words(2).join("#{i}") 
    desc = Faker::Lorem.words(1000).join(" ") 
    link = "http://dl.dropbox.com/u/71404227/100896-p-2x.png"
    store.products.create!(:title => title, :description => desc, 
                          :price => rand(2000) +1, :image_link => link)
  end
end

def seed_users(count)
  count.times do |i|
    puts "seeding user #{i}"
    User.create!(  full_name: "full_name#{i}",
              password: "hungry",
              password_confirmation: "hungry",
              email: "user#{i}@example.com",
              username: "user#{i}")
  end
end



def seed_orders(store, count)

  count.times do |i|
    puts "seeding order #{i}"
    o = store.orders.create(
     user: User.all.sample
     )
    product = store.products.sample
    o.order_items.create!(
     product_id: product.id,
     quantity: 1,
     unit_price: product.price
     )
  end
end


products = first_store.products.create([{ title: 'Moccasin', 
                       description: 'For that Pokahontas look.', 
                             price: 125.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/100896-p-2x.png",
                        categories: [female_category, boot_category]},
                           { title: 'Doc Marten', 
                       description: 'Stay in the 90s forever!', 
                             price: 99.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/930896-p-2x.png",
                        categories: [female_category, male_category, boot_category]},
                           { title: 'Cool-Foot Luke', 
                       description: "A nice mix of smooth, comfy, and spiffy.", 
                             price: 55.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1337701-p-2x.png",
                        categories: [male_category, casual_category]},
                           { title: 'Wooden Heels', 
                       description: "Get taller and sound like a Dutch person.", 
                             price: 75.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1445361-p-2x.png",
                        categories: [female_category, casual_category, dress_category]},
                           { title: 'Toe Shoe', 
                       description: 'Make all the gorillas think you stole their feet', 
                             price: 1.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1497950-p-2x.png",
                        categories: [female_category, male_category, wtf_category]},
                           { title: 'Basketball Dunker', 
                       description: 'Be like Mike. Look like Charles. (turrible).', 
                             price: 150.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1657767-p-2x.png",
                        categories: [male_category, casual_category]},
                           { title: 'Fancy Thong', 
                       description: 'Cork sole. Bedazzled straps.', 
                             price: 29.99, 
                        image_link: "http://dl.dropbox.com/u/71404227/1691205-p-2x.png",
                        categories: [male_category, casual_category]},
                           { title: 'The Yoho', 
                       description: 'Shoes make the man.', 
                             price: 75.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1694664-p-2x.png",
                        categories: [male_category, casual_category]},
                           { title: 'The Bowler', 
                       description: 'Teach me how to Turkey. Teach me, teach me, teach me how to Turkey', 
                             price: 150.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1706574-p-2x.png",
                        categories: [male_category, dress_category]},
                           { title: 'Gnome Stompers', 
                       description: 'Garden your face off, and then stomp on some gnomes', 
                             price: 35.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1709942-p-2x.png",
                        categories: [female_category, casual_category, wtf_category]},
                           { title: 'Mary Jane', 
                       description: 'Do not let this be your last dance with Mary Jane', 
                             price: 69.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1721291-p-2x.png",
                        categories: [female_category, casual_category]},
                           { title: 'Clown Cars', 
                       description: 'Jam all your toes in these silly little vehicles', 
                             price: 65.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1724907-p-2x.png",
                        categories: [female_category, male_category, casual_category, wtf_category]},
                           { title: 'Prep City', 
                       description: 'As if yachting was not preppy enough, we added some plaid.', 
                             price: 70.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1733785-p-2x.png",
                        categories: [female_category, casual_category]},
                           { title: 'The Mandal', 
                       description: 'Nobody should buy these, but if you have to, buy from us.', 
                             price: 17.99, 
                        image_link: "http://dl.dropbox.com/u/71404227/1739176-p-2x.png",
                        categories: [male_category, casual_category]},
                           { title: 'Cool-Foot Luke', 
                       description: 'Taking them off here, boss. Putting them back on here, boss.', 
                             price: 79.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1756451-p-2x.png",
                        categories: [male_category, casual_category]},
                           { title: 'The Wing-Man', 
                       description: 'A man is only as good as hiw Wing-Man', 
                             price: 149.99, 
                        image_link: "http://dl.dropbox.com/u/71404227/1757886-p-2x.png",
                        categories: [male_category, casual_category, dress_category]},
                           { title: 'Buck-Nasty', 
                       description: 'Get neu-buck nasty in these loafers', 
                             price: 125.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1760845-p-2x.png",
                        categories: [male_category, dress_category]},
                           { title: 'Lady Lightning', 
                       description: 'Zero to Hero at the speed of light.', 
                             price: 95.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1773825-p-2x.png",
                        categories: [female_category, casual_category]},
                           { title: 'Flat Out Fancy', 
                       description: 'All the fancy, none of the fear of heights', 
                             price: 99.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1780225-p-2x.png",
                        categories: [female_category, dress_category]},
                           { title: 'Why Not?', 
                       description: 'Sometimes you just have to put on orange loafers', 
                             price: 5000.50, 
                        image_link: "http://dl.dropbox.com/u/71404227/1799661-p-2x.png",
                        categories: [male_category, dress_category, wtf_category]},
                           { title: 'Pan Boots', 
                       description: 'No need for Tinkerbell, you will be fly enough without her', 
                             price: 159.00, 
                        image_link: "http://dl.dropbox.com/u/71404227/1780225-p-2x.png",
                        categories: [female_category, dress_category]}])

seed_products(second_store, 10000)
seed_users(500)
seed_orders(second_store, 5000)

admin_user = User.new(  full_name: "Chad Fowler",
                        password: "hungry",
                        password_confirmation: "hungry",
                        email: "demoXX+chad@jumpstartlab.com",
                        username: "SaxPlayer" )

admin_user.admin = true
admin_user.save

u = User.create!(  full_name: "Matt Yoho",
              password: "hungry",
              password_confirmation: "hungry",
              email: "demoXX+matt@jumpstartlab.com" )

User.create(  full_name: "Jeff",
              password: "hungry",
              password_confirmation: "hungry",
              email: "demoXX+jeff@jumpstartlab.com",
              username: "j3" )

Address.create(  street_1: "10 Street",
                  city: "Washington",
                state: "DC",
                     zip_code: "20001",
                  user: admin_user)

#stocker = User.create(  full_name: "Andy G",
#              password: "hungry",
#              password_confirmation: "hungry",
#              email: "demoXX+jeff@jumpstartlab.com",
#              username: "j3" )



# orders = Order.create([{ status: "pending", total_price: 5000},
#                       { status: "shipped", total_price: 10000}])

# order_items = OrderItem.new( 
#   quantity: 10, 
#   unit_price: 50, 
#   product_id: products.first.id,
#   order_id: orders.first.id )

# order_items.save

# order_items = OrderItem.create([{ quantity: 10, 
#   unit_price: 50, 
#   product_id: products[2].id,
#   order_id: orders.first.id}])



