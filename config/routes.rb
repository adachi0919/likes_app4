Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show, :create] do
    resources :likes, only: [:create, :destroy]
  end

  root 'posts#index'
  get '/posts/hashtag/:name', to: 'posts#hashtags'
end
