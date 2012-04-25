StoreEngine::Application.routes.draw do

  resources :products
  resources :orders
  resources :users
  resources :visitor_orders
  resources :sessions
  resources :unique_orders, :only => :show
  resources :cart_items
  resources :categories, :except => [:index]
  resource :two_click_orders
  resource :dashboard, :controller => 'dashboard'
  resource :checkout, :controller => 'checkout'

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"

  resource :cart, :only => [:show, :update]
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

  root :to => 'stores#index'

  resources :stores
  
end
