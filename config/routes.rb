Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users

  resources :questions do
    resources :answers
  end
  
  get '/my_questions', to: 'questions#index', scope: 'my', as: 'my_questions'

end

