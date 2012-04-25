StoreEngine::Application.routes.draw do
  devise_for :users

  get "checkout_prompt" => "carts#prompt", :as => "checkout_prompt"
  get "add_category_to_product" => "admin/categories#add_product", :as => "add_category_to_product"

  namespace :admin do
    resources :orders
    resources :order_items
    resources :products
    resources :categories
    resource :dashboard

    put "product_retire" => "products#retire_product", :as => "product_retire"
  end

  scope ":store" do
    get '/' => "stores#show"
    get "checkout" => "carts#checkout", :as => "checkout"
    get "billing" => "users#billing", :as => "billing"
    post "billing" => "users#finalize_order", :as => "billing"

    resources :products
    resources :categories
    resources :orders
    resource :cart, :only => [:show, :update]
    resource :cart_item, :only => [:destroy]
  end 

  root :to => "stores#index"
end
