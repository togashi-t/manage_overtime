Rails.application.routes.draw do
  get 'overtimes/index'
  get 'overtimes/create'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
