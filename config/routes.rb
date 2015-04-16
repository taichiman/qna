Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users

  resources :questions do
    resources :answers
  end
end
