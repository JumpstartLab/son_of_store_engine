StoreEngine::Application.routes.draw do

  resources :users, only: [:show, :create, :new, :update]

  resource  :cart, only: [:show, :update]
  resources :sessions
  resources :cart_products, only: [:new, :update, :destroy]
  # resource  :cart_product, only: []
  # resources :products, only: [:index, :show] do
  #   resource :retirement, only: [:create, :update]
  #   resource :categories, only: :show
  # end
  #resources :categories , only: [:show]
  resources :orders, only: [:index, :new, :show, :create]
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
    resources :stores
  end

  scope "/:url_name" do 
    resources :products, only: [:index, :show] do
      resource :retirement, only: [:create, :update]
    end
    resources :categories , only: [:show]
    match '', :to => 'products#index'
  end 

  match '/admin/dashboard', :to => 'admin/dashboard#show'
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  #match '/code' => redirect("https://github.com/mikesea/store_engine"), :as => :code
  
  root :to => "static_pages#home"
  #root :to => "products#index"

end
