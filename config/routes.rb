Rails.application.routes.draw do
  scope module: 'api' do
    resources :users, only: [ :create, :show ]
    resources :tests, only: [ :index, :show ] do
      resources :questions, only: [ :index ]
      resources :answers,   only: [ :create ]
      resources :results,   only: [ :index ]

      get 'use-code/:code', to: 'access_codes#use', as: 'use_code'
    end

    post 'register', to: 'users#create', as: :register
    post 'sign-in', to: 'users#sign_in'
    post 'sign-out', to: 'users#sign_out'

    constraints(escaped_email: /[^\/]+/) do
      get 'confirm/:escaped_email/:token', to: 'users#confirm'
    end

    get 'profile', to: 'users#show'
  end

  namespace :educators do
    resources :educators, only: [ :index, :new, :create, :show, :edit, :update ]
    resource :educator_sessions, only: [ :new, :create ]

    get 'login', to: 'educator_sessions#new'
    post 'login', to: 'educator_sessions#create'
    delete 'logout', to: 'educator_sessions#destroy'

    root to: 'educator_sessions#new'
  end

  root to: redirect('https://www.starteur.com/')

  match '*others', to: 'authenticated#allow', via: [ :options ]

end
