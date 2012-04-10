StoreEngine::Application.routes.draw do
  resource :cart
  resources :cart_items
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  resources :users
  resources :sessions
  resources :products
  resources :orders

  root :to => 'products#index'
end