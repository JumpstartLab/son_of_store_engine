require 'fabrication'

10.times { |n| Fabricate(:store, :name => "Store #{n}", :slug => "store-#{n}") }
100.times { Fabricate(:product, :photo => '', :store => Store.all.sample) }
10.times { Fabricate(:category) }

Product.all.each do |product|
  c = Category.all.sample
  c.store = product.store
  c.save()
  c.add_product(product)
end

20.times do
  Product.all.sample.add_category(Category.all.sample)
end

["pending", "cancelled", "paid", "shipped", "returned"].each do |status|
  3.times { Fabricate(:order, :status => status) }
end

User.create(
  :name => 'Matt Yoho',
  :email => 'demo10+matt@jumpstartlab.com',
  :password => 'hungry'
)

User.create(
  :name => 'Jeff',
  :email => 'demo10+jeff@jumpstartlab.com',
  :password => 'hungry',
  :username => 'j3'
)

User.create(
  :name => 'Chad Fowler',
  :email => 'demo10+chad@jumpstartlab.com',
  :password => 'hungry',
  :username => 'SaxPlayer'
).add_role(Role.create(:name => 'admin'))
