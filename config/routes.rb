Rails.application.routes.draw do
  scope module: 'api' do
    resources :users, only: [ :create, :show ]
    resources :tests, only: [ :index, :show ] do
      resources :questions, only: [ :index ]
      resources :answers,   only: [ :create ]
    end

    post 'register', to: 'users#create', as: :register
    get 'confirm/:escaped_email/:token', to: 'users#confirm', as: 'confirm', :constraints => { :escaped_email => /[^\/]+/ }
    post 'sign-in', to: 'users#sign_in'

    # Dashboard
    get 'profile', to: 'users#show'
  end

  root to: redirect('https://www.starteur.com/')

end
