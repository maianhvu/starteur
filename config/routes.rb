Rails.application.routes.draw do
  scope module: 'api' do
    resources :users, only: [ :create, :show ]
    resources :tests, only: [ :index, :show ] do
      resources :questions, only: [ :index ]
      resources :answers,   only: [ :create ]
    end

    post 'register', to: 'users#create', as: :register
    post 'sign-in', to: 'users#sign_in'

    constraints(escaped_email: /[^\/]+/) do
      get 'confirm/:escaped_email/:token', to: 'users#confirm'
    end

    match 'profile', to: 'users#show', via: [ :get, :options ]
  end

  root to: redirect('https://www.starteur.com/')

end
