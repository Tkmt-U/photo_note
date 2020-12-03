Rails.application.routes.draw do
  devise_for :users
  get 'users/mypage'
  resources :users, only: [:show, :edit, :update]

  get 'homes/about'

  get '/' => 'photos#index'
  get 'sort' => 'photos#sort'
  resources :photos, except: [:index] do
    resource :favorites, only: [:create, :destroy]
  end

  resources :tags, only: [:show]
end
