#!/usr/bin/env zsh

sed 's/cart_path/store_cart_path/' ./**.rb


#                     cart GET    /:store_slug/cart(.:format)                                  stores/carts#show
#                          PUT    /:store_slug/cart(.:format)                                  stores/carts#update
#         new_cart_product GET    /:store_slug/cart_products/new(.:format)                     stores/cart_products#new
#             cart_product PUT    /:store_slug/cart_products/:id(.:format)                     stores/cart_products#update
#                          DELETE /:store_slug/cart_products/:id(.:format)                     stores/cart_products#destroy
#       product_categories GET    /:store_slug/products/:product_id/categories(.:format)       stores/categories#show
#                 products GET    /:store_slug/products(.:format)                              stores/products#index
#                  product GET    /:store_slug/products/:id(.:format)                          stores/products#show
#                 category GET    /:store_slug/categories/:id(.:format)                        stores/categories#show
#                   orders POST   /:store_slug/orders(.:format)                                stores/orders#create
#                new_order GET    /:store_slug/orders/new(.:format)                            stores/orders#new
#             guest_orders GET    /:store_slug/guest_orders(.:format)                          stores/guest_orders#index
#                          POST   /:store_slug/guest_orders(.:format)                          stores/guest_orders#create
#          new_guest_order GET    /:store_slug/guest_orders/new(.:format)                      stores/guest_orders#new
#              guest_order GET    /:store_slug/guest_orders/:id(.:format)                      stores/guest_orders#show
#             credit_cards GET    /:store_slug/credit_cards(.:format)                          stores/credit_cards#index
#                          POST   /:store_slug/credit_cards(.:format)                          stores/credit_cards#create
#          new_credit_card GET    /:store_slug/credit_cards/new(.:format)                      stores/credit_cards#new
#         shipping_details GET    /:store_slug/shipping_details(.:format)                      stores/shipping_details#index
#                          POST   /:store_slug/shipping_details(.:format)                      stores/shipping_details#create
#      new_shipping_detail GET    /:store_slug/shipping_details/new(.:format)                  stores/shipping_details#new
#                    calls GET    /:store_slug/calls(.:format)                                 stores/calls#index
#                          POST   /:store_slug/calls(.:format)                                 stores/calls#create
#                 new_call GET    /:store_slug/calls/new(.:format)                             stores/calls#new
# admin_product_retirement POST   /:store_slug/admin/products/:product_id/retirement(.:format) stores/admin/retirements#create
#                          PUT    /:store_slug/admin/products/:product_id/retirement(.:format) stores/admin/retirements#update
#           admin_products GET    /:store_slug/admin/products(.:format)                        stores/admin/products#index
#                          POST   /:store_slug/admin/products(.:format)                        stores/admin/products#create
#        new_admin_product GET    /:store_slug/admin/products/new(.:format)                    stores/admin/products#new
#       edit_admin_product GET    /:store_slug/admin/products/:id/edit(.:format)               stores/admin/products#edit
#            admin_product GET    /:store_slug/admin/products/:id(.:format)                    stores/admin/products#show
#                          PUT    /:store_slug/admin/products/:id(.:format)                    stores/admin/products#update
#                          DELETE /:store_slug/admin/products/:id(.:format)                    stores/admin/products#destroy
#         admin_categories GET    /:store_slug/admin/categories(.:format)                      stores/admin/categories#index
#                          POST   /:store_slug/admin/categories(.:format)                      stores/admin/categories#create
#       new_admin_category GET    /:store_slug/admin/categories/new(.:format)                  stores/admin/categories#new
#      edit_admin_category GET    /:store_slug/admin/categories/:id/edit(.:format)             stores/admin/categories#edit
#           admin_category GET    /:store_slug/admin/categories/:id(.:format)                  stores/admin/categories#show
#                          PUT    /:store_slug/admin/categories/:id(.:format)                  stores/admin/categories#update
#                          DELETE /:store_slug/admin/categories/:id(.:format)                  stores/admin/categories#destroy
#       admin_order_status PUT    /:store_slug/admin/orders/:order_id/status(.:format)         stores/admin/statuses#update
#             admin_orders GET    /:store_slug/admin/orders(.:format)                          stores/admin/orders#index
#              admin_order GET    /:store_slug/admin/orders/:id(.:format)                      stores/admin/orders#show
#                          PUT    /:store_slug/admin/orders/:id(.:format)                      stores/admin/orders#update
#              admin_users POST   /:store_slug/admin/users(.:format)                           stores/admin/users#create
#           new_admin_user GET    /:store_slug/admin/users/new(.:format)                       stores/admin/users#new
#               admin_user GET    /:store_slug/admin/users/:id(.:format)                       stores/admin/users#show
#                          PUT    /:store_slug/admin/users/:id(.:format)                       stores/admin/users#update
#                          DELETE /:store_slug/admin/users/:id(.:format)                       stores/admin/users#destroy
#               admin_role DELETE /:store_slug/admin/roles/:id(.:format)                       stores/admin/roles#destroy
#         edit_admin_store GET    /:store_slug/admin/store/edit(.:format)                      stores/admin/stores#edit
#              admin_store PUT    /:store_slug/admin/store(.:format)                           stores/admin/stores#update
#    admin_store_admin_new        /:store_slug/admin/store_admin/new(.:format)                 stores/admin/users#new
#  admin_store_stocker_new        /:store_slug/admin/store_stocker/new(.:format)               stores/admin/users#new
#                    admin        /:store_slug/admin(.:format)                                 stores/admin/dashboard#show
# 
# 
#             admin_stores GET    /admin/stores(.:format)                                      admin/stores#index
#                          PUT    /admin/stores/:id(.:format)                                  admin/stores#update
#                          GET    /admin/products(.:format)                                    admin/products#index
#                          POST   /admin/products(.:format)                                    admin/products#create
#                          GET    /admin/products/new(.:format)                                admin/products#new
#                          GET    /admin/products/:id/edit(.:format)                           admin/products#edit
#                          GET    /admin/products/:id(.:format)                                admin/products#show
#                          PUT    /admin/products/:id(.:format)                                admin/products#update
#                          DELETE /admin/products/:id(.:format)                                admin/products#destroy
#                          GET    /admin/categories(.:format)                                  admin/categories#index
#                          POST   /admin/categories(.:format)                                  admin/categories#create
#                          GET    /admin/categories/new(.:format)                              admin/categories#new
#                          GET    /admin/categories/:id/edit(.:format)                         admin/categories#edit
#                          GET    /admin/categories/:id(.:format)                              admin/categories#show
#                          PUT    /admin/categories/:id(.:format)                              admin/categories#update
#                          DELETE /admin/categories/:id(.:format)                              admin/categories#destroy
#                          PUT    /admin/orders/:order_id/status(.:format)                     admin/statuses#update
#                          GET    /admin/orders(.:format)                                      admin/orders#index
#                          GET    /admin/orders/:id(.:format)                                  admin/orders#show
#                          PUT    /admin/orders/:id(.:format)                                  admin/orders#update
#                     root        /                                                            static#home
# 
