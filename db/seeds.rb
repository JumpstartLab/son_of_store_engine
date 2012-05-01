Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Product.destroy_all
Order.destroy_all
LineItem.destroy_all
BillingMethod.destroy_all
ShippingAddress.destroy_all
User.destroy_all
Category.destroy_all
ProductCategorization.destroy_all
Store.destroy_all

matt = User.create(full_name: 'Matt Yoho',
  email_address: 'demo11+matt@jumpstartlab.com', display_name: '',
  password: 'hungry')
jeff = User.create(full_name: 'Jeff Casimir',
  email_address: 'demo11+jeff@jumpstartlab.com',
  display_name: 'j3', password: 'hungry')
chad = User.create(full_name: 'Chad Fowler',
 email_address: 'demo11+chad@jumpstartlab.com',
 display_name: 'SaxPlayer', password: 'hungry')
chad.update_attribute(:admin, true)

### STORE 1 ###

store = Store.create(name: 'Cool Runnings', domain: 'cool-runnings', description: 'This is a moderately description for a store that I love. It is the best place in the world.')
store.update_attribute(:creating_user_id, jeff.id)
store.update_attribute(:approval_status, "pending")
store.update_attribute(:enabled, false)

admin = User.create(full_name: 'Cool Running Admin',
 email_address: 'cool.runnings.admin@jumpstartlab.com',
 display_name: 'CoolRunningAdmin', password: 'hungry')
Fabricate(:store_admin_permission, user_id: admin.id, store_id: store.id)

stocker = User.create(full_name: 'Cool Running Stocker',
 email_address: 'cool.runnings.stocker@jumpstartlab.com',
 display_name: 'CoolRunningStocker', password: 'hungry')
Fabricate(:store_stocker_permission, user_id: stocker.id, store_id: store.id)

['Bikes', 'Shoes', 'Helmets', 'Tires', 'Accessories' ].each do |cat|
  Category.create(name: cat, store_id: store.id)
end

products = []
#Bikes
products << Product.create(title: 'Zoomer', description: 'fast and affordable', price: "999.99", photo_url: 'http://swipe.swipelife.netdna-cdn.com/wp-content/uploads/2009/08/trek-urban-bikes-main.jpg', category_ids: [Category.find_by_name('Bikes').id.to_s], store_id: store.id)
products << Product.create(title: 'Boomer', description: 'fast and reliable', price: "1500", photo_url: 'http://swipe.swipelife.netdna-cdn.com/wp-content/uploads/2009/08/trek-urban-bikes-main.jpg', category_ids: [Category.find_by_name('Bikes').id.to_s], store_id: store.id)
products << Product.create(title: 'Racer', description: 'dead fast', price: "2000", photo_url: 'http://www.beautifullife.info/wp-content/uploads/2010/09/04/04.jpg', category_ids: [Category.find_by_name('Bikes').id.to_s], store_id: store.id)
products << Product.create(title: 'Cruiser', description: 'enjoys the road', price: "1499.99", photo_url: 'http://www.thecycler.net/photos/urban_outfitters_1-w600h361.jpg', category_ids: [Category.find_by_name('Bikes').id.to_s], store_id: store.id)
products << Product.create(title: 'Commuter', description: 'gets you to work', price: "1799.50", photo_url: 'http://yatzer.com/assets/Article/2312/images/Bamboocycle-A-Sustainable-Urban-Bicycle-yatzer-6.jpg', category_ids: [Category.find_by_name('Bikes').id.to_s], store_id: store.id)
#Shoes
products << Product.create(title: 'Razor', description: 'so comfortable', price: "99.99", photo_url: 'http://www.extremesupply.com/Merchant2/graphics/00000001/600x600/sidi/sidi_bicycle_shoes/sidi_hydro_gtx_shoes.jpg', category_ids: [Category.find_by_name('Shoes').id.to_s], store_id: store.id)
products << Product.create(title: 'Blader', description: 'perfect fit', price: "50", photo_url: 'http://recklesscognition.files.wordpress.com/2009/01/51fe2hm5cml_sidi-blaze-womens-mountain-bike-shoes-steel_.jpg', category_ids: [Category.find_by_name('Shoes').id.to_s], store_id: store.id)
products << Product.create(title: 'Tesler', description: 'strong and durable', price: "150", photo_url: 'http://www.bicyclebuys.com/productimages/DITRMTBM8PART.jpg', category_ids: [Category.find_by_name('Shoes').id.to_s], store_id: store.id)
products << Product.create(title: 'FlexSole', description: 'always smell like roses', price: "200", photo_url: 'http://bikereviews.com/wp-content/uploads/2009/10/cannondale-aerospeed-comp-cycling-shoes.jpg', category_ids: [Category.find_by_name('Shoes').id.to_s], store_id: store.id)
products << Product.create(title: 'Carbonite', description: 'strong carbon fiber sole', price: "120", photo_url: 'http://origin-cdn.volusion.com/sb4jw.nuvx9/v/vspfiles/photos/7735068250605-2T.jpg', category_ids: [Category.find_by_name('Shoes').id.to_s], store_id: store.id)
#Helmets
products << Product.create(title: 'Streaker', description: 'so comfortable', price: "100", photo_url: 'http://moobike.com/wp-content/uploads/2011/02/Specialized-Racing-Bike-Helmet-Prevail-Black.jpg', category_ids: [Category.find_by_name('Helmets').id.to_s], store_id: store.id)
products << Product.create(title: 'Dark Knight', description: 'perfect fit', price: "200", photo_url: 'http://www.productwiki.com/upload/images/fox_racing_flux_mountain_bike_helmet.jpg', category_ids: [Category.find_by_name('Helmets').id.to_s], store_id: store.id)
products << Product.create(title: 'XC90', description: 'strong and durable', price: "150", photo_url: 'http://media.rei.com/media/tt/32cf3cca-0d8f-4a64-84a2-58664df39b58.jpg', category_ids: [Category.find_by_name('Helmets').id.to_s], store_id: store.id)
products << Product.create(title: 'Rover', description: 'protects your melon', price: "199.50", photo_url: 'http://ecx.images-amazon.com/images/I/51y95sPCMaL.jpg', category_ids: [Category.find_by_name('Helmets').id.to_s], store_id: store.id)
products << Product.create(title: 'Thick Head', description: 'looks great', price: "75", photo_url: 'http://media.tumblr.com/tumblr_lzshngrNdQ1r6d1joo1_500.jpg', category_ids: [Category.find_by_name('Helmets').id.to_s], store_id: store.id)
#Tires
products << Product.create(title: 'BollingerX', description: 'nails stand no chance', price: "100", photo_url: 'http://www.rei.com/zoom/ww/a0f87a2a-aeef-4a60-91d9-d30200b811fc.jpg', category_ids: [Category.find_by_name('Tires').id.to_s], store_id: store.id)
products << Product.create(title: 'Trek5', description: 'perfect fit', price: "50", photo_url: 'http://spiritualtravelman.files.wordpress.com/2007/09/bike-tire.jpg', category_ids: [Category.find_by_name('Tires').id.to_s, Category.find_by_name('Bikes').id.to_s], store_id: store.id)
products << Product.create(title: 'Cannondale5', description: 'strong and durable', price: "75", photo_url: 'http://media.rei.com/media/211384.jpg', category_ids: [Category.find_by_name('Tires').id.to_s, Category.find_by_name('Bikes').id.to_s], store_id: store.id)
products << Product.create(title: 'AlphaBlue', description: 'smoothes your ride', price: "80", photo_url: 'http://luxlow.com/wp-content/uploads/wpsc/product_images/ti27color1.jpg', category_ids: [Category.find_by_name('Tires').id.to_s, Category.find_by_name('Bikes').id.to_s], store_id: store.id)
products << Product.create(title: 'Warrior', description: 'looks great', price: "30", photo_url: 'http://www.rei.com/zoom/ee/d4be100d-a394-4a1f-bfd2-964fb5b0b9f7.jpg', category_ids: [Category.find_by_name('Tires').id.to_s, Category.find_by_name('Bikes').id.to_s], store_id: store.id)
#Accessories
products << Product.create(title: 'Water Bottle', description: 'stay hydrated in style', price: "10", photo_url: 'http://reviews.roadbikereview.com/files/2009/12/camelbak_podium.jpg', category_ids: [Category.find_by_name('Accessories').id.to_s], store_id: store.id)
products << Product.create(title: 'Heart Rate Pro', description: 'none slip and accurate', price: "100", photo_url: 'http://runningwatchguide.com/wp-content/uploads/2011/11/Polar-RS300X-Heart-Rate-Monitor2.jpg', category_ids: [Category.find_by_name('Accessories').id.to_s], store_id: store.id)
products << Product.create(title: 'Sunglasses', description: 'blocks all UV light', price: "80", photo_url: 'http://www.vpcam.com/members/1402226/uploaded/10882.jpg', category_ids: [Category.find_by_name('Accessories').id.to_s], store_id: store.id)
products << Product.create(title: 'Clipless Pedals', description: 'for racers', price: "75", photo_url: 'http://www.cyclesportandfitness.com/images/WPD-95B.jpg', category_ids: [Category.find_by_name('Accessories').id.to_s, Category.find_by_name('Bikes').id.to_s ], store_id: store.id)
products << Product.create(title: 'Toe Clips', description: 'perfect for commuting', price: "30", photo_url: 'http://www.bikegallery.com/blog/wp-content/uploads/2010/08/toeclip.jpg', category_ids: [Category.find_by_name('Accessories').id.to_s, Category.find_by_name('Bikes').id.to_s ], store_id: store.id)

#ORDERS
orders = []
2.times do
  ["paid", "shipped", "cancelled", "returned"].each do |status|
    orders << Order.create(status: status, user_id: User.all.sample.id, store_id: store.id)
  end
end

#LineItems

orders.each do
  ((rand*5+1).to_i).times do
    prod = products.sample
    LineItem.create(order_id: orders.sample.id, price: prod.price, product_id: prod.id, quantity: (1..5).to_a.sample)
  end
end

### STORE 2 ###

store2 = Store.create(name: 'Cool Sunglasses', domain: 'cool-sunglasses', description: 'This store sucks. Honestly, it was the worst shopping experience I have ever had. Monkeys run a tighter ship.')
store2.update_attribute(:creating_user_id, matt.id)
store2.update_attribute(:approval_status, "approved")
store2.update_attribute(:enabled, true)

admin = User.create(full_name: 'Cool Sunglasses Admin',
 email_address: 'cool.sunglasses.admin@jumpstartlab.com',
 display_name: 'CoolSunglassesAdmin', password: 'hungry')
Fabricate(:store_admin_permission, user_id: admin.id, store_id: store2.id)

stocker = User.create(full_name: 'Cool Sunglasses Stocker',
 email_address: 'cool.sunglasses.stocker@jumpstartlab.com',
 display_name: 'CoolSunglassesStocker', password: 'hungry')
Fabricate(:store_stocker_permission, user_id: stocker.id, store_id: store2.id)

['Bikes'.reverse, 'Shoes'.reverse, 'Helmets'.reverse, 'Tires'.reverse, 'Accessories'.reverse ].each do |cat|
  Category.create(name: cat, store_id: store2.id)
end

products = []
#Bikes
products << Product.create(title: 'Zoomer'.reverse, description: 'fast and affordable', price: "999.99", photo_url: 'http://swipe.swipelife.netdna-cdn.com/wp-content/uploads/2009/08/trek-urban-bikes-main.jpg', category_ids: [Category.find_by_name('Bikes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Boomer'.reverse, description: 'fast and reliable', price: "1500", photo_url: 'http://swipe.swipelife.netdna-cdn.com/wp-content/uploads/2009/08/trek-urban-bikes-main.jpg', category_ids: [Category.find_by_name('Bikes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Racer'.reverse, description: 'dead fast', price: "2000", photo_url: 'http://www.beautifullife.info/wp-content/uploads/2010/09/04/04.jpg', category_ids: [Category.find_by_name('Bikes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Cruiser'.reverse, description: 'enjoys the road', price: "1499.99", photo_url: 'http://www.thecycler.net/photos/urban_outfitters_1-w600h361.jpg', category_ids: [Category.find_by_name('Bikes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Commuter'.reverse, description: 'gets you to work', price: "1799.50", photo_url: 'http://yatzer.com/assets/Article/2312/images/Bamboocycle-A-Sustainable-Urban-Bicycle-yatzer-6.jpg', category_ids: [Category.find_by_name('Bikes'.reverse).id.to_s], store_id: store2.id)
#Shoes
products << Product.create(title: 'Razor'.reverse, description: 'so comfortable', price: "99.99", photo_url: 'http://www.extremesupply.com/Merchant2/graphics/00000001/600x600/sidi/sidi_bicycle_shoes/sidi_hydro_gtx_shoes.jpg', category_ids: [Category.find_by_name('Shoes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Blader'.reverse, description: 'perfect fit', price: "50", photo_url: 'http://recklesscognition.files.wordpress.com/2009/01/51fe2hm5cml_sidi-blaze-womens-mountain-bike-shoes-steel_.jpg', category_ids: [Category.find_by_name('Shoes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Tesler'.reverse, description: 'strong and durable', price: "150", photo_url: 'http://www.bicyclebuys.com/productimages/DITRMTBM8PART.jpg', category_ids: [Category.find_by_name('Shoes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'FlexSole'.reverse, description: 'always smell like roses', price: "200", photo_url: 'http://bikereviews.com/wp-content/uploads/2009/10/cannondale-aerospeed-comp-cycling-shoes.jpg', category_ids: [Category.find_by_name('Shoes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Carbonite'.reverse, description: 'strong carbon fiber sole', price: "120", photo_url: 'http://origin-cdn.volusion.com/sb4jw.nuvx9/v/vspfiles/photos/7735068250605-2T.jpg', category_ids: [Category.find_by_name('Shoes'.reverse).id.to_s], store_id: store2.id)
#Helmets
products << Product.create(title: 'Streaker'.reverse, description: 'so comfortable', price: "100", photo_url: 'http://moobike.com/wp-content/uploads/2011/02/Specialized-Racing-Bike-Helmet-Prevail-Black.jpg', category_ids: [Category.find_by_name('Helmets'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Dark Knight'.reverse, description: 'perfect fit', price: "200", photo_url: 'http://www.productwiki.com/upload/images/fox_racing_flux_mountain_bike_helmet.jpg', category_ids: [Category.find_by_name('Helmets'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'XC90'.reverse, description: 'strong and durable', price: "150", photo_url: 'http://media.rei.com/media/tt/32cf3cca-0d8f-4a64-84a2-58664df39b58.jpg', category_ids: [Category.find_by_name('Helmets'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Rover'.reverse, description: 'protects your melon', price: "199.50", photo_url: 'http://ecx.images-amazon.com/images/I/51y95sPCMaL.jpg', category_ids: [Category.find_by_name('Helmets'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Thick Head'.reverse, description: 'looks great', price: "75", photo_url: 'http://media.tumblr.com/tumblr_lzshngrNdQ1r6d1joo1_500.jpg', category_ids: [Category.find_by_name('Helmets'.reverse).id.to_s], store_id: store2.id)
#Tires
products << Product.create(title: 'BollingerX'.reverse, description: 'nails stand no chance', price: "100", photo_url: 'http://www.rei.com/zoom/ww/a0f87a2a-aeef-4a60-91d9-d30200b811fc.jpg', category_ids: [Category.find_by_name('Tires'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Trek5'.reverse, description: 'perfect fit', price: "50", photo_url: 'http://spiritualtravelman.files.wordpress.com/2007/09/bike-tire.jpg', category_ids: [Category.find_by_name('Tires'.reverse).id.to_s, Category.find_by_name('Bikes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Cannondale5'.reverse, description: 'strong and durable', price: "75", photo_url: 'http://media.rei.com/media/211384.jpg', category_ids: [Category.find_by_name('Tires'.reverse).id.to_s, Category.find_by_name('Bikes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'AlphaBlue'.reverse, description: 'smoothes your ride', price: "80", photo_url: 'http://luxlow.com/wp-content/uploads/wpsc/product_images/ti27color1.jpg', category_ids: [Category.find_by_name('Tires'.reverse).id.to_s, Category.find_by_name('Bikes'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Warrior'.reverse, description: 'looks great', price: "30", photo_url: 'http://www.rei.com/zoom/ee/d4be100d-a394-4a1f-bfd2-964fb5b0b9f7.jpg', category_ids: [Category.find_by_name('Tires'.reverse).id.to_s, Category.find_by_name('Bikes'.reverse).id.to_s], store_id: store2.id)
#Accessories
products << Product.create(title: 'Water Bottle'.reverse, description: 'stay hydrated in style', price: "10", photo_url: 'http://reviews.roadbikereview.com/files/2009/12/camelbak_podium.jpg', category_ids: [Category.find_by_name('Accessories'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Heart Rate Pro'.reverse, description: 'none slip and accurate', price: "100", photo_url: 'http://runningwatchguide.com/wp-content/uploads/2011/11/Polar-RS300X-Heart-Rate-Monitor2.jpg', category_ids: [Category.find_by_name('Accessories'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Sunglasses'.reverse, description: 'blocks all UV light', price: "80", photo_url: 'http://www.vpcam.com/members/1402226/uploaded/10882.jpg', category_ids: [Category.find_by_name('Accessories'.reverse).id.to_s], store_id: store2.id)
products << Product.create(title: 'Clipless Pedals'.reverse, description: 'for racers', price: "75", photo_url: 'http://www.cyclesportandfitness.com/images/WPD-95B.jpg', category_ids: [Category.find_by_name('Accessories'.reverse).id.to_s, Category.find_by_name('Bikes'.reverse).id.to_s ], store_id: store2.id)
products << Product.create(title: 'Toe Clips'.reverse, description: 'perfect for commuting', price: "30", photo_url: 'http://www.bikegallery.com/blog/wp-content/uploads/2010/08/toeclip.jpg', category_ids: [Category.find_by_name('Accessories'.reverse).id.to_s, Category.find_by_name('Bikes'.reverse).id.to_s ], store_id: store2.id)

#ORDERS
orders = []
2.times do
  ["paid", "shipped", "cancelled", "returned"].each do |status|
    orders << Order.create(status: status, user_id: User.all.sample.id, store_id: store2.id)
  end
end

#LineItems

orders.each do
  ((rand*5+1).to_i).times do
    prod = products.sample
    LineItem.create(order_id: orders.sample.id, price: prod.price, product_id: prod.id, quantity: (1..5).to_a.sample)
  end
end

### STORE 3 ###

store3 = Store.create(name: 'Slow Runnings', domain: 'slow-runnings', description: 'This store is really slow. Honestly, it was the worst shopping experience I have ever had. Monkeys run a faster ship.')
store3.update_attribute(:creating_user_id, matt.id)
store3.update_attribute(:approval_status, "approved")
store3.update_attribute(:enabled, true)

admin = User.create(full_name: 'Slow Runnings Admin',
 email_address: 'slow.runnings.admin@jumpstartlab.com',
 display_name: 'SlowRunningsAdmin', password: 'hungry')
Fabricate(:store_admin_permission, user_id: admin.id, store_id: store3.id)

stocker = User.create(full_name: 'SlowRunnings Stocker',
 email_address: 'slow.runnings.stocker@jumpstartlab.com',
 display_name: 'SlowRunningsStocker', password: 'hungry')
Fabricate(:store_stocker_permission, user_id: stocker.id, store_id: store3.id)

# PRODUCTS
products = []
100.times do
  products << Fabricate(:product, store_id: store3.id)
end

# ORDERS
orders = []
1000.times do
  ["paid", "shipped", "cancelled", "returned"].each do |status|
    orders << Order.create(status: status, user_id: User.all.sample.id, store_id: store3.id)
  end
end

#LineItems
orders.each do
  ((rand*5+1).to_i).times do
    prod = products.sample
    LineItem.create(order_id: orders.sample.id, price: prod.price, product_id: prod.id, quantity: (1..5).to_a.sample)
  end
end
