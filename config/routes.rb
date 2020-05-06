Rails.application.routes.draw do
  root "users#index"
  devise_for :users
  resources :users, only: [:index, :show]
  resource :overtimes, only: [:create, :update, :destroy]
end
