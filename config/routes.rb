Rails.application.routes.draw do
  root to: 'static_pages#home'
  resources :books
  resources :users
  resources :authors
    
  get 'users/:id/confirm_delete', to: 'users#confirm_delete', as: 'confirm_delete_user'

  get 'authors/:id/confirm_delete', to: 'authors#confirm_delete', as: 'confirm_delete_author'
    
    
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
