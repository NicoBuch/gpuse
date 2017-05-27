Rails.application.routes.draw do
  root to: 'application#index'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'

  mount ActionCable.server => '/cable'

  resources :publishers, only: [] do
    collection do
      post :sign_up
      get :sign_in
      put :update_eth_address
      post :publish
      get :completed_publication
    end
  end

  resources :subscribers, only: [] do
    collection do
      post :sign_up
      get :sign_in
      post :completed_frame
    end
  end
end
