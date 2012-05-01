 StoreEngine::Application.routes.draw do
  require 'resque/server'

  mount Resque::Server.new, :at => "/resque"
  
  get "login" => 'sessions#new' 
  get "logout" => 'sessions#destroy', :as => "logout"

  
  resources :sessions

  resources :users, :exclude => [:index] do
    collection do
      # Not yet needed
      # get 'signup_as_store_admin'
      # put 'create_store_admin'
    end
  end

  # Admin Routes
  namespace "admin" do
    get "dashboard" => "dashboard#index"
    resources :categories, :products, :sales, :exclude => [:show]
    resources :users, :only => [:index, :destroy]
    resources :stores do
      member do
        put "approve"
        put "decline"
        put 'enable'
        put 'disable'
      end
    end
    resources :orders,:exclude => [:show] do
      member do
        get 'status'
      end
    end
    resources :store_roles
  end

  namespace "stock" do
    resources :products
  end

  # Subdomain Routes
  scope '', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' } do
    resources :search, :categories
    resources :sales, :only => [:show, :index]
    get 'admin' => "admin::stores#manage"

    resources :products, :only => [:show, :index] do
      resources :product_ratings, :only => [:create, :edit, :update]
    end
    resources :categories, :only => [:show, :index]
    resources :orders, :only => [:show, :new] do
      collection do
        put 'charge'
        get 'track'
        get 'my_orders'
      end
    end

    resource :cart do
      member do
        post 'guest'
        put 'update_quantity'
        put :two_click
      end
    end
    root :to => "products#index"
  end

  get '/profile', :to => "users#edit", as: :profile
  get '/', to: "pages#index", as: :home
  root :to => "pages#index"
end