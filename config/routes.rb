require 'resque/server'

StoreEngine::Application.routes.draw do

  get "info/home"

  mount Resque::Server.new, :at => "/resque"

  match '/code' => redirect("https://github.com/mikesea/store_engine"), :as => :code

  resources :users, only: [:show, :create, :new, :edit, :update] do
    resources :orders, :only => [:index, :show]
  end

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
    resources :orders, only: [:new, :create]
    resources :guest_orders, only: [:index, :new, :show, :create]
    resources :credit_cards, only: [:new, :create, :index]
    resources :shipping_details, only: [:new, :create, :index]
    resources :calls, only: [:new, :create, :index]

    namespace :admin do
      #resource :store, only: [:edit, :update]
      resources :products do
        resource :retirement, only: [:create, :update]
      end
      resources :categories
      resources :orders, only: [:index, :show, :update] do
        resource :status, only: :update
      end
      resources :users, only: [:show, :new, :create, :destroy, :update]
      resources :roles, only: :destroy
      match 'store_admin/new', :to => 'users#new'
      match 'store_stocker/new', :to => 'users#new'
    end
    match '/admin', :to => 'admin/dashboard#show'
    match '/admin/edit', :to => 'admin/stores#edit'
  end

  namespace :admin do
    resources :stores, only: [:index, :update]
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :update] do
      resource :status, only: :update
    end
  end

  root :to => "static#home"
end
