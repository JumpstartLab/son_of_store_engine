As an authenticated Administrator, I can:




As an Administrator, I can also view an order "dashboard" where I can:

Line item subtotal
Status of the order
Links to transition to other statuses as explained above

As a Public User, I can:

Remove a product from my cart
Increase the quantity of a product in my cart
Checkout by entering my billing information, shipping address, and email address

View the status of my order:
Accessible at a special, unique URL
Displays the current status, total, date placed, products with quantity purchased and line-item totals
If shipped or cancelled, display a timestamp when that action took place
Security and Usability

Unauthenticated Users

Allowed To:

log in which should not clear the cart (merge carts)

NOT Allowed To:

checkout (until they log in)


Authenticated Non-Administrators

Allowed To:

view their past orders
view any product on the order

if any product is retired:
that should be included in the display
they cannot add it to a new cart
NOT Allowed To:

view another public users’s private data (such as current shopping cart, etc.)
view the administrator screens or use administrator functionality
make themselves an administrator
Administrators

Allowed To:

View, create, and edit products and categories
View and edit orders; may change quantity of products, remove products from orders, or change the status of an order
Edit orders which are pending by changing quantity of a products on the order
Change the status of an order according to the rules as outlined above
NOT Allowed To:

Modify public user personal data
Data Validity

There are several types of entities in the system, each with requirements about what makes for a valid record. These restrictions are summarized below.

Any attempt to create/modify a record with invalid attributes should return the user to the input form with a validation error indicating the problem along with suggestions how to fix it.

Product

A product must have a title, description, and price.
The title and description cannot be empty strings.
The title must be unique for all products in the system
The price must be a valid decimal numeric value and greater than zero
The photo is optional. If present it must be a valid URL format.
User

A user must have a valid email address that is unique to all users
A user must have a full name that is not blank
A user may optionally provide a display name that must be no less than 2 characters long and no more than 32
Order

An order must belong to a user
An order must be for one or more of one or more products currently being sold

SEED EXAMPLE DATA