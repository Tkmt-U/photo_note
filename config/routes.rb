Rails.application.routes.draw do
  devise_for :users
  get 'users/mypage'
  resources :users, only: [:show, :edit, :update]

  get 'homes/about'

  get '/' => 'photos#index'
  resources :photos, except: [:index] do
    resource :favorites, only: [:create, :destroy]
  end
end
