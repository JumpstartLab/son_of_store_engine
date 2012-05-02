Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Product.destroy_all
Order.destroy_all
LineItem.destroy_all
BillingMethod.destroy_all
ShippingAddress.destroy_all
User.destroy_all
Category.destroy_all
ProductCategorization.destroy_all
Store.destroy_all
StorePermission.destroy_all

IMAGE_ARRAY = ["https://s3.amazonaws.com/StoreEngine/box.png",
               "https://s3.amazonaws.com/StoreEngine/present.png",
               "https://s3.amazonaws.com/StoreEngine/brown-bag.png",
               "https://s3.amazonaws.com/StoreEngine/puzzle.png"]

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

10000.times do
  Fabricate(:user)
end

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

categories = []
10.times do
  categories << Fabricate(:category, store_id: store.id)
end

33000.times do
  Fabricate(:product, store_id: store.id, image_url: IMAGE_ARRAY[rand(4)], category_ids: [categories[rand(10)]])
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

categories = []
10.times do
  categories << Fabricate(:category, store_id: store2.id)
end

33000.times do
  Fabricate(:product, store_id: store2.id, image_url: IMAGE_ARRAY[rand(4)], category_ids: [categories[rand(10)]])
end

### STORE 3 ###

store3 = Store.create(name: 'Cool Beans', domain: 'cool-beans', description: 'This store is really slow. Honestly, it was the worst shopping experience I have ever had. Monkeys run a faster ship.')
store3.update_attribute(:creating_user_id, matt.id)
store3.update_attribute(:approval_status, "approved")
store3.update_attribute(:enabled, true)

admin = User.create(full_name: 'Cool Beans Admin',
 email_address: 'cool.beans.admin@jumpstartlab.com',
 display_name: 'CoolBeansAdmin', password: 'hungry')
Fabricate(:store_admin_permission, user_id: admin.id, store_id: store3.id)

stocker = User.create(full_name: 'Cool Beans Stocker',
 email_address: 'cool.beans.stocker@jumpstartlab.com',
 display_name: 'CoolBeansStocker', password: 'hungry')
Fabricate(:store_stocker_permission, user_id: stocker.id, store_id: store3.id)

categories = []
10.times do
  categories << Fabricate(:category, store_id: store3.id)
end

34000.times do
  Fabricate(:product, store_id: store3.id, image_url: IMAGE_ARRAY[rand(4)], category_ids: [categories[rand(10)]])
end