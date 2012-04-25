StoreEngine::Application.routes.draw do
  root to: "stores#index"

  get 'sessions/new', :as => 'login_page'
  get 'sessions/index'
  post 'sessions/create', :as => 'login'
  delete 'sessions/destroy', :as => 'logout'

  match '/code' => redirect('http://github.com/athal7/store_engine')

  match '/profile' => "users#profile"

  resources :users, except: :destroy
  resources :billing_methods, except: [:destroy]
  resources :shipping_addresses, except: [:destroy]

  namespace :admin do
    resources :stores
  end

  resources :stores, only: [:index, :new, :create]


  scope "/:domain" do
    match "/" => "products#index"
    resources :products, only: [:index, :show]
    resources :categories, only: [:index, :show]
    resources :orders, except: [:new, :create, :destroy] do
      member do
        get :lookup
      end
    end
    resources :line_items, except: [:new]
    namespace :admin do
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
