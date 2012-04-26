StoreEngine::Application.routes.draw do

  match 'profile' => "stores#new"
  root :to => "static_pages#home"
  resources :users, only: [:show, :create, :new, :update]
  resources :stores, only: [:index, :new, :create]
  get "guest/new" => "guest#new", as: "new_guest"
  post "guest" => "guest#create", as: "guest"
  get "guest/shipping" => "guest#guest_shipping", as: "guest_shipping"
  post "guest/payment" => "guest#guest_payment", as: "guest_payment"
  post "guest/order" => "guest#guest_order", as: "guest_order"
  resource  :cart, only: [:show, :update]

  resources :sessions
  resources :cart_products, only: [:new, :update, :destroy]

  match '/admin/dashboard', :to => 'admin/dashboard#show'
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  scope "", constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' } do
    match '', :to => 'stores#show', as: :store
    match '/admin/dashboard', :to => 'admin/dashboard#show', as: "admin_dashboard"


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
      resource :dashboards, only: [:show]
      resources :orders, only: [:index, :show, :update] do
        resource :status, only: :update
      end
      resources :users, only: [:show]
      resources :stores
    end
    #root to: "products#index"
  end 

  #match '/code' => redirect("https://github.com/mikesea/store_engine"), :as => :code
  #root :to => "products#index"

end
