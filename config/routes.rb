Rails.application.routes.draw do
  root to: 'application#index'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'

  resources :publishers, only: [] do
    collection do
      post :sign_up
      get :sign_in
      put :update_eth_address
    end
  end
end
