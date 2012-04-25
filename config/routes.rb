StoreEngine::Application.routes.draw do
  get "login" => 'sessions#new'
  get "logout" => 'sessions#destroy', :as => "logout"
  root :to => "products#index"

  resources :sessions, :pages
  resources :users, :exclude => [:index]

  resources :categories, :only => [:show]

  match '', to: 'products#index', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  root :to => "pages#index"

  namespace "store_admin" do
    resources :categories, :products, :sales, :exclude => [:show]
    resources :users, :only => [:index, :destroy]
    resources :orders,:exclude => [:show] do
      member do
        get 'status'
      end
    end
  end

 
  resources :search, :categories
  resources :sales, :only => [:show, :index]
  
  resources :sales, :only => [:show, :index]
  resources :categories, :only => [:show]
  
  resources :products, :only => [:show, :index] do
    resources :product_ratings, :only => [:create, :edit, :update]
  end  
  

  resources :orders, :only => [:show, :new] do
    collection do
      put 'charge'
      get 'track'
      get 'my_orders'
    end
  end

  resource :cart do
    member do
      put 'update_quantity'
      put :two_click
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  namespace "store_admin" do
    resources :categories, :products, :sales, :exclude => [:show]
    resources :users, :only => [:index, :destroy]
    resource  :dashboard
    resources :orders,:exclude => [:show] do
      member do
        get 'status'
      end
    end
  end
end
