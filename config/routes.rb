Rails.application.routes.draw do
  root "overtimes#index"
  devise_for :users
  resources :users, only: :show
  resources :overtimes
end
