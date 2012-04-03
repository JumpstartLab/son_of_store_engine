StoreEngine::Application.routes.draw do
  resources :categories do 
    resources :products
  end
  resources :products

  root :to => 'products#index'
end
