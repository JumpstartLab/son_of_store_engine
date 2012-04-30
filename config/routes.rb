 StoreEngine::Application.routes.draw do
  require 'resque/server'

  mount Resque::Server.new, :at => "/resque"
  get "login" => 'sessions#new' 
  get "logout" => 'sessions#destroy', :as => "logout"

  resources :sessions, :pages
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
      collection do
        get 'users'
        put 'add_user'
        get 'user_stocker'
        put 'add_stocker'
        put 'remove_role'
      end
    end
    resources :orders,:exclude => [:show] do
      member do
        get 'status'
      end
    end
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

  root :to => "pages#index"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end