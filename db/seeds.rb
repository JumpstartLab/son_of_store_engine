# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(:name => "Matt Yoho",
            :email => "demoXX+matt@jumpstartlab.com",
            :password => "hungry")
User.create(:name => "Jeff Casimir",
            :email => "demoXX+jeff@jumpstartlab.com",
            :display_name => "j3",
            :password => "hungry")
admin = User.new( :name => "Chad Fowler",
                  :email => "demoXX+chad@jumpstartlab.com",
                  :display_name => "SaxPlayer",
                  :password => "hungry")
admin.is_admin = true
admin.save

Customer.create(:user_id => 2,
                :ship_address => "123 Petworth Avenue NW",
                :ship_state => "DC",
                :ship_zipcode => "20009",
                :stripe_customer_token => "asdf19993asdfn")

Customer.create(:user_id => 3,
                :ship_address => "1445 New York Avenue NW",
                :ship_state => "DC",
                :ship_zipcode => "20001",
                :stripe_customer_token => "asdf123asdfn")

Category.create(:name => "Tech & Gadgets")
Category.create(:name => "Cook & Prep")
Category.create(:name => "Gifts")
Category.create(:name => "Men's Shop")
Category.create(:name => "Makes You Smile")

Product.create( :title => "Water Powered Alarm Clock",
                :description => "This Bedol Water Clock in Smiley Blue keeps perfect time without batteries or electricity.",
                :price => 1925,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/2317-300x300-1309358233-primary.png",
                :on_sale => true,
                :category_ids => [1,5])
Product.create( :title => "60s Kodak Camera",
                :description => "Displayed in-store in the 1960s.",
                :price => 59900,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/71182-300x300-1329256767-primary.png",
                :on_sale => true,
                :category_ids => [1,4])
Product.create( :title => "Cookie Making Set",
                :description => "1950s cookie gun with attachments in original box.",
                :price => 5400,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/114314-360x360-1334158574-primary.png",
                :on_sale => true,
                :category_ids => [1,2])
Product.create( :title => "German Ceramic Pretzel Flask",
                :description => "A circa 1960s flask and it happens to be shaped like life-size pretzel.",
                :price => 17500,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/114759-300x300-1334252671-primary.png",
                :on_sale => true,
                :category_ids => [2,3])
Product.create( :title => "Charcuterie Variety Pack",
                :description => "Includes 10-12 oz. herb pancetta, 6-7 oz. fennel salami, 6-7 oz. sweet sopressata and 6-7 oz. chorizo. ",
                :price => 2600,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/80471-300x300-1330724251-primary.png",
                :on_sale => true,
                :category_ids => [2,4])
Product.create( :title => "Macadamia Bitters",
                :description => "Take part in the cocktail renaissance with an exotic twist.",
                :price => 775,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/114129-300x300-1334087992-primary.png",
                :on_sale => true,
                :category_ids => [2])
Product.create( :title => "Black and White Truffle Butters",
                :description => "Pieces of the coveted earthy edibles are blended with creamy butter to produce a deep, musky flavor that melts into every bite.",
                :price => 2700,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/80449-300x300-1330445728-primary.png",
                :on_sale => true,
                :category_ids => [2,3])
Product.create( :title => "Ketchup Pillow",
                :description => "The Meninos Ketchup Pillow has 57 comfortable positions to offer, so you might as well ketchup on your relaxation time.",
                :price => 1800,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/114392-300x300-1334179561-primary.png",
                :on_sale => true,
                :category_ids => [3])
Product.create( :title => "Prohibition Hip Flask",
                :description => "Faux leather- bound hip flask. 6 oz. steel fabric-wrapped hip flask.",
                :price => 1300,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/115050-300x300-1334182745-primary.png",
                :on_sale => true,
                :category_ids => [3, 4])
Product.create( :title => "Tasters in a Tin",
                :description => "The p.o.p. Tasters in a Tin has oodles of p.o.p. Mix Butter Crunch in snack-sized packs.",
                :price => 2400,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/113416-300x300-1334077633-primary.png",
                :on_sale => true,
                :category_ids => [2,3])
Product.create( :title => "Striped Suspenders",
                :description => "Nothing beats a solid, stylish pair of suspenders for catching the eye of your amore.",
                :price => 2500,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/114215-300x300-1334155146-primary.png",
                :on_sale => true,
                :category_ids => [4])
Product.create( :title => "Nothing Special Watch",
                :description => "Go ahead, hang a Warhol on your wrist.",
                :price => 1700,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/119146-300x300-1334329803-primary.png",
                :on_sale => true,
                :category_ids => [1,4])
Product.create( :title => "DEVO Robot Tee",
                :description => "Offers a crazy image that brings together sex and commercialism.",
                :price => 2275,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/113062-300x300-1334001260-primary.png",
                :on_sale => true,
                :category_ids => [4,5])
Product.create( :title => "Switchblade Necklace",
                :description => "Adding just the barest hint of sinister sexy that is so very wonderful.",
                :price => 6900,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/114470-300x300-1334250924-primary.png",
                :on_sale => true,
                  :category_ids => [4])
Product.create( :title => "Burgerlog Plush",
                :description => "A more-than-faintly horrifying stuffed animal described as eight inches of swirly, corny goodness.",
                :price => 1250,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/115857-300x300-1334264710-primary.png",
                :on_sale => true,
                  :category_ids => [4,5])
Product.create( :title => "Concrete Zen Tray",
                :description => "Each tray features a polished surface, elegantly tapered sides and a raised lip to keep your daily essentials in harmony with the universe.",
                :price => 3200,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/119393-300x300-1334590069-primary.png",
                :on_sale => true,
                  :category_ids => [3,4])
Product.create( :title => "Fiberglass EAT Sign",
                :description => "This bubbly fiberglass EAT sign is every inch a glossy memento of Mid-Century typography.",
                :price => 18400,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/114516-300x300-1334163514-primary.png",
                :on_sale => true,
                  :category_ids => [5])
Product.create( :title => "1977 Farrah Poster",
                :description => "1977 Poster of Farrah Fawcett in a Hanae Mori bathing suit made for Los Angeles Magazine and sold through the Farrah Fawcett Fan Club.",
                :price => 6300,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/114754-300x300-1334252405-primary.png",
                :on_sale => true,
                  :category_ids => [4,5])
Product.create( :title => "Pac-Man Wall Decal",
                :description => "Turn your living room into an arcade, not in the French sense, in the hangout at the mall and play games all day sense of your youth!",
                :price => 4500,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/119509-300x300-1334344765-primary.png",
                :on_sale => true,
                  :category_ids => [1,5])
Product.create( :title => "Hands Coaster 4 Pack",
                :description => "They are especially handy for preventing stray pixels from staining your table.",
                :price => 1050,
                :image_url => "http://s3.amazonaws.com/static.fab.com/product/114204-300x300-1334178960-primary.png",
                :on_sale => true,
                  :category_ids => [1,5])

Order.create(:status => "paid",
             :customer_id => 2)
Order.create(:status => "paid",
             :customer_id => 1)
Order.create(:status => "pending",
             :customer_id => 2)
Order.create(:status => "pending",
             :customer_id => 1)
order = Order.create(:status => "cancelled",
             :customer_id => 2)
order.cancelled = Date.today
order.save
order = Order.create(:status => "cancelled",
             :customer_id => 1)
order.cancelled = Date.today
order.save
order = Order.create(:status => "shipped",
             :customer_id => 2)
order.shipped = Date.today
order.save
order = Order.create(:status => "shipped",
             :customer_id => 1)
order.shipped = Date.today
order.save
order = Order.create(:status => "returned",
             :customer_id => 2)
order.shipped = Date.today
order.save
order = Order.create(:status => "returned",
             :customer_id => 1)
order.shipped = Date.today
order.save

OrderItem.create(:order_id => 1, :product_id => 1, :quantity => 1, :price => Product.find_by_id(1).price)
OrderItem.create(:order_id => 1, :product_id => 2, :quantity => 2, :price => Product.find_by_id(2).price)
OrderItem.create(:order_id => 2, :product_id => 3, :quantity => 1, :price => Product.find_by_id(3).price)
OrderItem.create(:order_id => 2, :product_id => 4, :quantity => 3, :price => Product.find_by_id(4).price)
OrderItem.create(:order_id => 2, :product_id => 5, :quantity => 1, :price => Product.find_by_id(5).price)
OrderItem.create(:order_id => 3, :product_id => 6, :quantity => 4, :price => Product.find_by_id(6).price)
OrderItem.create(:order_id => 4, :product_id => 7, :quantity => 1, :price => Product.find_by_id(7).price)
OrderItem.create(:order_id => 4, :product_id => 8, :quantity => 5, :price => Product.find_by_id(8).price)
OrderItem.create(:order_id => 4, :product_id => 9, :quantity => 1, :price => Product.find_by_id(9).price)
OrderItem.create(:order_id => 5, :product_id => 10, :quantity => 6, :price => Product.find_by_id(10).price)
OrderItem.create(:order_id => 5, :product_id => 11, :quantity => 1, :price => Product.find_by_id(11).price)
OrderItem.create(:order_id => 6, :product_id => 12, :quantity => 2, :price => Product.find_by_id(12).price)
OrderItem.create(:order_id => 6, :product_id => 13, :quantity => 1, :price => Product.find_by_id(13).price)
OrderItem.create(:order_id => 7, :product_id => 14, :quantity => 3, :price => Product.find_by_id(14).price)
OrderItem.create(:order_id => 7, :product_id => 15, :quantity => 1, :price => Product.find_by_id(15).price)
OrderItem.create(:order_id => 7, :product_id => 16, :quantity => 4, :price => Product.find_by_id(16).price)
OrderItem.create(:order_id => 7, :product_id => 17, :quantity => 1, :price => Product.find_by_id(17).price)
OrderItem.create(:order_id => 8, :product_id => 18, :quantity => 2, :price => Product.find_by_id(18).price)
OrderItem.create(:order_id => 8, :product_id => 19, :quantity => 1, :price => Product.find_by_id(19).price)
OrderItem.create(:order_id => 8, :product_id => 20, :quantity => 3, :price => Product.find_by_id(20).price)
OrderItem.create(:order_id => 8, :product_id => 1, :quantity => 1, :price => Product.find_by_id(1).price)
OrderItem.create(:order_id => 9, :product_id => 2, :quantity => 4, :price => Product.find_by_id(2).price)
OrderItem.create(:order_id => 9, :product_id => 3, :quantity => 1, :price => Product.find_by_id(3).price)
OrderItem.create(:order_id => 9, :product_id => 4, :quantity => 4, :price => Product.find_by_id(4).price)
OrderItem.create(:order_id => 9, :product_id => 5, :quantity => 1, :price => Product.find_by_id(5).price)
OrderItem.create(:order_id => 10, :product_id => 6, :quantity => 3, :price => Product.find_by_id(6).price)
OrderItem.create(:order_id => 10, :product_id => 7, :quantity => 1, :price => Product.find_by_id(7).price)
OrderItem.create(:order_id => 10, :product_id => 8, :quantity => 2, :price => Product.find_by_id(8).price)
OrderItem.create(:order_id => 10, :product_id => 9, :quantity => 1, :price => Product.find_by_id(9).price)
OrderItem.create(:order_id => 10, :product_id => 10, :quantity => 2, :price => Product.find_by_id(10).price)
OrderItem.create(:order_id => 10, :product_id => 11, :quantity => 1, :price => Product.find_by_id(11).price)
OrderItem.create(:order_id => 10, :product_id => 12, :quantity => 2, :price => Product.find_by_id(12).price)
