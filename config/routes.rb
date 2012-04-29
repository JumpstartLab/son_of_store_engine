StoreEngine::Application.routes.draw do
  get "stores/edit"

  devise_for :users

  devise_scope :user do
    get "users/new" => "devise/registrations#new", :as => :new_user 
  end

  match 'profile' => 'stores#new'
  get "tracking/:slug" => "trackings#show", :as => "tracking"

  resources :roles
  resources :stores
  resources :users

  namespace :superadmin, :path => "admin" do
    resources :stores
  end

  scope ":slug" do
    get "checkout_prompt" => "carts#prompt", :as => "checkout_prompt"
    get "add_category_to_product" => "admin/categories#add_product", :as => "add_category_to_product"
    namespace :admin do
      get '/' => 'dashboards#show'
      resources :orders
      resources :users
      resources :order_items
      resources :store_users, only: :create
      resources :products
      resources :categories
      resource :dashboard

      put "product_retire" => "products#retire_product", :as => "product_retire"
    end

    get '/' => "stores#show"
    get "checkout" => "carts#checkout", :as => "checkout"
    get "billing" => "users#billing", :as => "billing"
    post "billing" => "users#finalize_order", :as => "billing"

    resources :products
    resources :categories
    resources :orders
    resource :cart, :only => [:show, :update]
    resource :cart_item, :only => [:destroy]
  end 

  root :to => "stores#index"
end
