StoreEngine::Application.routes.draw do

  resources :users, only: [:show, :create, :new, :update]
  resource :cart, only: [:show]

  resources :sessions
  resources :stores, only: [:index]
  match '/admin/dashboard', :to => 'admin/dashboard#show'
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  root :to => "static_pages#home"

  scope "/:url_name" do
    match '', :to => 'products#index'

    resources :products, only: [:index, :show] do
      resource :retirement, only: [:create, :update]
    end

    resources :categories , only: [:show]

    resources :carts, only: [:show, :update], as: :store_cart
    resources :cart_products, only: [:new, :update, :destroy]
    resources :orders, only: [:index, :new, :show, :create]
    resources :credit_cards, only: [:new, :create, :index]
    resources :shipping_details, only: [:new, :create, :index]

    namespace :admin do
      resources :products
      resources :categories
      resources :orders, only: [:index, :show, :update] do
        resource :status, only: :update
      end
      resources :users, only: [:show]
      resource :dashboards, only: [:show]
      resources :stores
    end
  end 

  #match '/code' => redirect("https://github.com/mikesea/store_engine"), :as => :code
  

  #root :to => "products#index"

end
