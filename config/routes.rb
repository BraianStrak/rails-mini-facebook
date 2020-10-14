Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users
  resources :posts
  resources :comments
  resources :posts do
    resources :likes
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    authenticated :user do
      root 'posts#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  match 'auth/:provider/callback', to: 'devise/sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'devise/sessions#destroy', as: 'signout'

end
