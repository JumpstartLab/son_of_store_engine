StoreEngine::Application.routes.draw do
  get "login" => 'sessions#new'
  get "logout" => 'sessions#destroy', :as => "logout"
  root :to => "products#index"

  resources :sessions, :search, :store
  resources :users, :exclude => [:index]
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
