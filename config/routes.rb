StoreEngine::Application.routes.draw do
  devise_for :users

  get "signup" => "users#new", :as => "signup"
  get "checkout" => "carts#prompt", :as => "checkout"
  get "billing" => "users#billing", :as => "billing"
  post "billing" => "users#finalize_order", :as => "billing"
  get "add_category_to_product" => "admin/categories#add_product", :as => "add_category_to_product"

  resource :cart, :only => [:show, :update]
  resources :orders
  resource :cart_item, :only => [:destroy]
  resources :products
  resources :categories

  namespace :admin do
    resources :orders
    resources :order_items
    resources :products
    resources :categories
    resource :dashboard

    put "product_retire" => "products#retire_product", :as => "product_retire"
  end

  root :to => "products#index"
end
