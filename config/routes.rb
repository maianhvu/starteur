Rails.application.routes.draw do
  scope module: 'api' do
    resources :users, only: [ :create, :show ]
    resources :tests, only: [ :index, :show ] do
      resources :questions, only: [ :index ]
      resources :answers,   only: [ :create ]

      get 'use-code/:code', to: 'access_codes#use', as: 'use_code'
    end

    post 'register', to: 'users#create', as: :register
    post 'sign-in', to: 'users#sign_in'

    constraints(escaped_email: /[^\/]+/) do
      match 'confirm/:escaped_email/:token', to: 'users#confirm', via: [ :get, :options ]
    end

    match 'profile', to: 'users#show', via: [ :get, :options ]
  end

  root to: redirect('https://www.starteur.com/')

end
