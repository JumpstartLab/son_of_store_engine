StoreEngine::Application.routes.draw do

  resources :users
  resources :sessions
  
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
  match "/code" => redirect("http://github.com/chrismanderson/store_engine")
  match "/profile" => "users#profile", as: "profile"
  match "/dashboards" => "dashboard#index", as: "dashboards"

  root :to => 'stores#index'

  resources :stores do
    resources :products
    resource :dashboard, :controller => 'dashboard'
    resource :two_click_orders
    resources :categories, :except => [:index]
    resources :orders
    resource :checkout, :controller => 'checkout'
    resource :cart, :only => [:show, :update]
    resources :cart_items
    resources :unique_orders, :only => :show
    resources :visitor_orders
  end
  
end
