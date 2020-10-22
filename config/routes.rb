Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root to: 'homes#top'
    get 'home/about' => 'homes#about'

    resources :users, only: [:index, :show, :edit, :update] do#マイページ
        member do
            get :following, :followed
        end
    end
    resources :books, only: [:create, :index, :show, :edit, :update, :destroy] do #本の投稿
        resource :favorites, only: [:create, :destroy]
        resources :book_comments, only: [:create, :destroy] #コメント
    end

    get 'relationships/create'
    get 'relationships/destroy'
    post 'follow/:id' => 'relationships#follow', as: 'follow'
    post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
    get '/search' => 'search#search'
end
