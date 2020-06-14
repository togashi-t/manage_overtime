Rails.application.routes.draw do
  root "users#index"
  devise_for :users
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest"
  end
  resources :users, only: [:index, :show]
  resource :overtimes, only: [:create, :update, :destroy]
  resources :requests, only: [:create, :edit, :update, :destroy]
end
