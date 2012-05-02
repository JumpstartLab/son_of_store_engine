StoreEngine::Application.routes.draw do

  resources :users
  resources :sessions
  resources :all_orders, :controller => 'user_orders'
  
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"

  namespace "admin" do
    resources :stores do
      put "enable", on: :member
      put "disable", on: :member
      put "approve", on: :member
      put "decline", on: :member
    end
  end
  match "/code" => redirect("https://github.com/tkiefhaber/son_of_store_engine")
  match "/profile" => "users#profile", as: "profile"

  match "/new" => "stores#new"
  match "/create" => "stores#create"

  match "/:store_id" => "stores#show", via: :get
  resources :stores, path: '' do
    resources :products
    resource :dashboard, :controller => 'dashboard'
    resource :two_click_orders
    resources :categories
    resources :orders
    resources :employees
    resource :checkout, :controller => 'checkout'
    resource :cart, :only => [:show, :update]
    resources :cart_items
    resources :unique_orders, :only => :show
    resources :visitor_orders
    resource :stocker_dashboard, :controller => 'stocker_dashboard', 
             :only => :show
    resources :store_orders, :only => [:index]
    match "stats/revenue_over_time" => "stats#revenue_over_time"
    match "stats/category_revenue" => "stats#category_revenue"
    match "stats/top_ten_user_revenue" => "stats#top_ten_user_revenue"
  end


  root :to => "stores#index"
end
