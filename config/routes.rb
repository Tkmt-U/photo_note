Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :edit, :update]
  get 'users/mypage'

  get 'homes/about'

  get '/' => 'photos#index'
  resources :photos, except: [:index] do
    resource :favorites, only: [:create, :destroy]
  end
end
