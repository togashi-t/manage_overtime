Rails.application.routes.draw do
  root 'overtimes#index'
  devise_for :users
  resources :overtimes
end
