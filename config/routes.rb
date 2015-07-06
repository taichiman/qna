Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  resources :questions, except: [:edit] do
    resources :answers, except: [:show, :edit]

    get '/my', to: 'questions#my', on: :collection
  end
  
  get 'answers/my', to: 'answers#index', as: 'my_answers'

  post '/best-answer/:id', to: 'answers#best_answer', as: 'best_answer'

end

