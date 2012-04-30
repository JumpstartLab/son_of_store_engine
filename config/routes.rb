StoreEngine::Application.routes.draw do
  require 'resque/server'
  mount Resque::Server.new, at: "/resque"
  root to: "stores#index"

  get 'sessions/new', :as => 'login_page'
  get 'sessions/index'
  post 'sessions/create', :as => 'login'
  delete 'sessions/destroy', :as => 'logout'

  match '/code' => redirect('http://github.com/athal7/son_of_store_engine')

  match '/profile' => "users#profile"

  resources :users, except: :destroy
  resources :billing_methods, except: [:destroy]
  resources :shipping_addresses, except: [:destroy]

  namespace :admin do
    resources :stores
  end

  resources :stores, only: [:index, :new, :create, :update]

  resources :store_permissions


  scope "/:domain" do
    match "/" => "products#index"
    match "orders/lookup" => "orders#lookup"
    resources :products, only: [:index, :show]
    resources :categories, only: [:index, :show]
    resources :orders, except: [:new, :create, :destroy]
    match '/admin' => 'admin/stores#show'
    resources :line_items, except: [:new]
    namespace :admin, module: "store_admin" do
      resources :orders
      resources :products do
        member  do
          put :retire
        end
      end
      resources :categories
      resources :users
    end
  end

end
