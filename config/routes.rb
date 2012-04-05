StoreEngine::Application.routes.draw do
  resource :cart, :only => :show
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  resources :users
  resources :sessions
  resources :categories do 
    resources :products
  end
  resources :products
  resources :orders

  root :to => 'products#index'
end
