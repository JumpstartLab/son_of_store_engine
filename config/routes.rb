StoreEngine::Application.routes.draw do

  get "info/home"

  match '/code' => redirect("https://github.com/mikesea/store_engine"), :as => :code

  resources :users, only: [:show, :create, :new, :update]
  resources :stores, :only => [:index, :create, :new]

  match '/profile', :to => "stores#index"

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  resources :sessions

  scope ':store_slug' do
    match '/', :to => 'products#index', :as => :store

    #resources :sessions  #XXX support login/logout from store
    resource  :cart, only: [:show, :update]
    resources :cart_products, only: [:new, :update, :destroy]
    resources :products, only: [:index, :show] do
      resource :retirement, only: [:create, :update]
      resource :categories, only: :show
    end

    resources :categories , only: [:show]
    resources :orders, only: [:index, :new, :show, :create]
    resources :guest_orders, only: [:index, :new, :show, :create]
    resources :credit_cards, only: [:new, :create, :index]
    resources :shipping_details, only: [:new, :create, :index]
    resources :calls, only: [:new, :create, :index]

    namespace :admin do
      resources :products
      resources :categories
      resources :orders, only: [:index, :show, :update] do
        resource :status, only: :update
      end
      resources :users, only: [:show]
      resource :dashboards, only: [:show]
    end

    match '/admin/dashboard', :to => 'admin/dashboard#show'
  end

  namespace :admin do
    resources :stores, only: [:index, :update]
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :update] do
      resource :status, only: :update
    end
    resource :dashboards, only: [:show]
  end

  root :to => "info#home"
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
