Rails.application.routes.draw do
  root "users#index"
  devise_for :users
  resources :users, only: [:index, :show]
  resources :overtimes, only: [:new, :create, :update, :destroy]
end
