StoreEngine::Application.routes.draw do

  get "info/home"

  match '/code' => redirect("https://github.com/mikesea/store_engine"), :as => :code

  resources :users, only: [:show, :create, :new, :edit, :update]
  resources :stores, :only => [:show, :index, :create, :new]

  match '/profile', :to => "stores#index"

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  resources :sessions

  scope ':store_slug', :module => "store" do
    match '/', :to => 'products#index', :as => :store

    resource  :cart, only: [:show, :update]
    resources :cart_products, only: [:new, :update, :destroy]
    resources :products, only: [:index, :show] do
      resource :categories, only: :show
    end

    resources :categories , only: [:show]
    resources :orders, only: [:index, :new, :show, :create]
    resources :guest_orders, only: [:index, :new, :show, :create]
    resources :credit_cards, only: [:new, :create, :index]
    resources :shipping_details, only: [:new, :create, :index]
    resources :calls, only: [:new, :create, :index]

    namespace :admin do
      resources :products do
        resource :retirement, only: [:create, :update]
      end
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

  root :to => "static#home"
end
